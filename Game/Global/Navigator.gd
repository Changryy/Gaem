extends Node

const CHARACTER_RADIUS = 25
const WALL_BIT_MASK = 8 + 16

var astar := AStar2D.new()
var ray: RayCast2D
var ray_holder: Node2D
var area_rays := []

export var visualise := false
export var animate := false
export var animation_delay := 0.1


func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	if !get_tree().has_group("wall"): return
	create_ray()
	create_points()
	connect_points()


func create_points() -> void:
	var id := 0
	#Go thorugh each wall polygon
	for wall in get_tree().get_nodes_in_group("wall"):
		var poly = wall.get_parent().polygon
		#Expand polygon
		poly = inflate(poly)
		#Go through each point in polygon
		for point in poly:
			if point_has_space(point):
#				if animate: yield(get_tree().create_timer(0.5), "timeout")
				astar.add_point(id, point)
				id += 1

func inflate(poly: PoolVector2Array) -> PoolVector2Array:
	return Geometry.offset_polygon_2d(poly, CHARACTER_RADIUS+1, 2)[0]

func connect_points() -> void:
	var point_count := astar.get_point_count()
	#Go through each point
	for a in point_count:
		#go through each point with a higher ID
		for b in range(a+1, point_count):
			if segment_has_space(astar.get_point_position(a),astar.get_point_position(b)):
				if animate: yield(get_tree().create_timer(animation_delay), "timeout")
				astar.connect_points(a,b)

func sort_distance(a: Vector2, b: Vector2) -> bool:
	return a.length_squared() < b.length_squared()

func add_point(point: Vector2):
#	var id := astar.get_closest_point(point)
#	if point.distance_to(astar.get_point_position(id)) > 0:
#		id = astar.get_available_point_id()
#		astar.add_point(id, point)
	var id := astar.get_available_point_id()
	astar.add_point(id, point)
	for i in astar.get_points():
		if i == id: continue
		if !segment_has_space(point, astar.get_point_position(i), true): continue
		astar.connect_points(id, i)
	return id


#check if point has enough space for traversal
func point_has_space(point: Vector2) -> bool:
	for r in area_rays:
		r.position = point
		r.force_raycast_update()
		if ray.is_colliding(): return false
	return true

#check if segment between 2 points has enough space for traversal
func segment_has_space(a: Vector2, b: Vector2, is_minimal:=false) -> bool:
	ray_holder.position = a
	ray_holder.look_at(b)
	ray.cast_to = Vector2.RIGHT * a.distance_to(b)
	ray.position = Vector2.ZERO
	if is_minimal:
		ray.force_raycast_update()
		if ray.is_colliding(): return false
	else:
		for i in range(-CHARACTER_RADIUS, CHARACTER_RADIUS):
			ray.position.y = i
			ray.force_raycast_update()
			if ray.is_colliding(): return false
	if !visualise: return true
	# draw line between points
	var line = Line2D.new()
	line.width = 3
	line.points = [a,b]
	line.light_mask = 16
	add_child(line)
	return true


func create_ray() -> void:
	ray_holder = Node2D.new()
	ray = RayCast2D.new()
	ray.collision_mask = WALL_BIT_MASK
	ray_holder.add_child(ray)
	add_child(ray_holder)
	
	for i in range(18):
		var new_ray = RayCast2D.new()
		new_ray.cast_to = Vector2.RIGHT*CHARACTER_RADIUS
		new_ray.rotation_degrees = i*20
		new_ray.collision_mask = WALL_BIT_MASK
		add_child(new_ray)
		area_rays.append(new_ray)


func remove_point(i):
	var point = astar.get_point_position(i)
	astar.remove_point(i)
	for line in get_children():
		if not line is Line2D: continue
		if point in line.points: line.queue_free()







