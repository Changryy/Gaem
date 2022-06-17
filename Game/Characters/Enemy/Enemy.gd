extends KinematicBody2D
signal arrived_at(pos)

export var speed = 300
export(NodePath) onready var detection = get_node(detection) as Polygon2D
export(bool) var debug_pathfinder := false
export(bool) var show_path := false

var path: PoolVector2Array = []
var nav: Node
var velocity := Vector2.ZERO

func walk_to(pos: Vector2) -> void:
	var a = nav.add_point(global_position)
	var b = nav.add_point(pos)
	if a == -1 or b == -1: return
	velocity = Vector2.ZERO
	path = nav.astar.get_point_path(a, b)
	if show_path:
		for line in get_tree().get_nodes_in_group("navline"): line.queue_free()
		var line = Line2D.new()
		line.width = 5
		line.default_color = Color.webmaroon
		line.points = path
		line.add_to_group("navline")
		nav.add_child(line)
	yield(self, "arrived_at")
	nav.remove_point(a)
	nav.remove_point(b)

func turn_towards(pos: Vector2) -> void:
	path.append(global_position + global_position.direction_to(pos)*10)

func _ready() -> void:
	if !get_tree().has_group("navigation"): return
	nav = get_tree().get_nodes_in_group("navigation")[0]
	if !debug_pathfinder: return
	yield(get_tree().create_timer(0.1), "timeout")
	$StateMachine.transition_to("Search", {
		search = global_position,
		direction = Vector2()
	})

func apply_rotation() -> void:
	detection.rotation = lerp_angle(
		detection.rotation,
		(path[0] - global_position).angle(),
		0.05
	)

func check_input() -> void:
	if debug_pathfinder:
		if Input.is_action_just_pressed("shoot"):
			walk_to(get_global_mouse_position())
		if Input.is_action_just_pressed("special"):
			turn_towards(get_global_mouse_position())
	if Input.is_action_just_released("dash"): print(path)

func is_path_obscured(idx: int = 0) -> bool:
	$Ray.position = Vector2.ZERO
	$Ray.cast_to = path[idx] - global_position
	$Ray.force_raycast_update()
	return $Ray.is_colliding() and $Ray.get_collision_point().distance_to(path[idx]) > 50

func accelerate() -> void:
	velocity = lerp(velocity, Vector2(speed,0), 0.1)
func decelerate() -> void:
	velocity = lerp(velocity, Vector2.ZERO, 0.1)

func apply_velocity() -> void:
	# stop if no path
	if !path:
		decelerate()
		return
	apply_rotation()
	# find new path if path is obscured
	if is_path_obscured():
		walk_to(path[-1])
		decelerate()
		return
	# otherwise follow path
	if len(path) > 1:
		if !is_path_obscured(1): path.remove(0)
		accelerate()
		return
	# continue walking until the last point is in visual range
	if global_position.distance_to(path[0]) > detection.distance * 0.8:
		accelerate()
		return
	# stop when the point is in range
	decelerate()
	var angle = rad2deg(abs(Vector2.RIGHT.rotated(detection.rotation
				).angle_to(global_position.direction_to(path[0]))))
	if angle > 5: return
	# only remove last point after looking directly at it
	var last = path[0]
	path = []
	emit_signal("arrived_at", last)


func _physics_process(_delta) -> void:
	check_input()
	apply_velocity()
	move_and_slide(velocity.rotated(detection.rotation))















