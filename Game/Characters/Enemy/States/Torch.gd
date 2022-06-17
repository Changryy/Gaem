extends State

export var colour := Color.white
export var light := Color.white
export var peak_mod := Color.white
export var peak_time := 0.1
export var adjust_time := 0.8
export var show_estimation := false
export var estimation_shadow := false

var search_point := Vector2()
var player_velocity := Vector2()
var exits := []
var pre_exit := Vector2()
var exit_point := Vector2()
var exit_time := 0
var start_point := Vector2()

func enter(msg:={}):
	var wait = true
	if "wait" in msg: wait = msg.wait
	owner.get_node("IndicatorSpawn").spawn("?")
	if wait: get_tree().create_timer(0.5).connect("timeout", self, "torch_on")
	search_point = msg.search
	player_velocity = msg.direction
	start_point = owner.global_position
	owner.detection.modulate = light
	owner.get_node("Sprite").modulate = colour
	if owner.debug_pathfinder: return
	find_exits()
	if player_velocity == Vector2.ZERO:
		exit_point = search_point
	else:
		exit_time = OS.get_ticks_msec()
		exit_by_direction()
	if !wait: torch_on()

func guess_exit():
	randomize()
	var points = {}
	var i := 0.0
	for x in exits:
		i += 1 / x.length()
		points[i] = x
	var magic_number = rand_range(0,i)
	for w in points:
		if magic_number < w:
			exit_point = points[w]
			pre_exit = exit_point
			break

func exit_by_direction():
	if !exits:
		exit_point = search_point
		return
	var line = Line2D.new()
	var min_val := INF
	for x in exits:
		var dist = search_point.direction_to(x).distance_squared_to(
			player_velocity.normalized()) + search_point.distance_to(x)/1000.0
		if dist < min_val:
			min_val = dist
			pre_exit = x
		if !show_estimation: continue
		var line2 = Line2D.new()
		line2.points = [search_point, x]
		line2.width = 2
		line2.default_color = Color(0,1,0,0.1)
		add_child(line2)
	exit_point = pre_exit
	line.add_point(search_point)
	line.add_point(pre_exit)
	
	var ray = owner.get_node("Ray2") as RayCast2D
	ray.position = Vector2.ZERO
	var points := []
	for i in owner.nav.astar.get_point_connections(owner.nav.astar.get_closest_point(pre_exit)):
		var point = owner.nav.astar.get_point_position(i)
		if pre_exit.distance_squared_to(point) > 250000: continue
		ray.cast_to = point - ray.global_position
		ray.force_raycast_update()
		if ray.is_colliding(): continue
		points.append(point - pre_exit)
	points.sort_custom(owner.nav, "sort_distance")
	ray.global_position = search_point
	for point in points:
		point += pre_exit
		ray.cast_to = point - ray.global_position
		ray.force_raycast_update()
		if ray.is_colliding():
			exit_point = point
			line.add_point(exit_point)
			break
	
	if !show_estimation: return
	line.width = 2
	if estimation_shadow: line.light_mask = 16
	line.default_color = Color(0,1,0)
	add_child(line)

# Scans the environment to guess where the player went
func find_exits():
	for c in get_children():
		if c is Line2D: c.queue_free()
	var ray = owner.get_node("Ray") as RayCast2D
	var ray2 = owner.get_node("Ray2") as RayCast2D
	ray.position = search_point - owner.global_position
	ray2.position = Vector2.ZERO
	ray.cast_to = Vector2(800,0)
	exits = []
	var last_point := Vector2.ZERO
	var last_normal := Vector2.ZERO
	var line = Line2D.new()
	for i in 720:
		var point := Vector2()
		var normal := Vector2()
		ray.rotation_degrees = i/2.0
		ray.force_raycast_update()
		if ray.is_colliding():
			point = ray.get_collision_point()
			normal = ray.get_collision_normal()
		else: point = ray.cast_to.rotated(ray.global_rotation) + ray.global_position
		if (i != 0 and last_point.distance_squared_to(point) >= 2500 and # 50
		min(last_point.distance_squared_to(search_point), point.distance_squared_to(search_point)) > 10000):
			var closest_waypoint := Vector2()
			var is_current_point = point.distance_squared_to(search_point) < last_point.distance_squared_to(search_point)
			if is_current_point: closest_waypoint = owner.nav.astar.get_point_position(owner.nav.astar.get_closest_point(point))
			else: closest_waypoint = owner.nav.astar.get_point_position(owner.nav.astar.get_closest_point(last_point))
			ray2.cast_to = closest_waypoint - owner.global_position
			ray2.force_raycast_update()
			if ray2.is_colliding():
				if is_current_point: exits.append(point + normal*25)
				else: exits.append(last_point + last_normal*25)
		if show_estimation: line.add_point(point)
		last_point = point
		last_normal = normal
	if !show_estimation: return
	line.add_point(line.points[0])
	line.width = 2
	line.default_color = Color.darkgreen
	if estimation_shadow: line.light_mask = 16
	add_child(line)

func torch_on():
	if owner.detection.visible:
		owner.walk_to(exit_point)
		return
	if !owner.debug_pathfinder:
		owner.detection.look_at(search_point)
	owner.detection.modulate = Color(0,0,0,0)
	owner.detection.reset().show()
	$Tween.interpolate_property(
		owner.detection, "modulate",
		owner.detection.modulate, peak_mod,
		peak_time, Tween.TRANS_QUAD, Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		owner.detection, "modulate",
		peak_mod, light,
		adjust_time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, peak_time
	)
	$Tween.start()


func found_player():
	if !is_active: return
	owner.path = []
	goto("Attack")


func arrived(pos):
	if !is_active or owner.debug_pathfinder: return
	match pos:
		search_point: owner.walk_to(start_point)
		pre_exit: owner.walk_to(search_point)
		exit_point: owner.walk_to(pre_exit)
		start_point:
			if get_tree().has_group("player"):
				owner.walk_to(get_tree().get_nodes_in_group("player")[0].global_position)
		_: goto("Scan")

func tween_completed():
	if !owner.debug_pathfinder: owner.walk_to(exit_point)
func exit(): $Tween.stop_all()
