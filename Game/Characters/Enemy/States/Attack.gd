extends State

export var colour := Color.white
export(Color) var light := Color.white
onready var ray = owner.get_node("Ray") as RayCast2D
var player: KinematicBody2D
var distance = 700
var dir := 0

func physics_update(delta):
	distance = player.best_distance
	if owner.path: owner.path = []
	apply_rotation()
	apply_movement(delta)
	check_for_player()

func check_for_player() -> void:
	ray.cast_to = player.global_position - ray.global_position
	ray.force_raycast_update()
	if !ray.is_colliding(): return
	goto("Search", {
		search = player.global_position,
		direction = player.velocity,
		wait = false
	})

func apply_rotation() -> void:
	owner.detection.rotation = lerp_angle(
		owner.detection.rotation,
		(player.global_position - owner.global_position).angle(),
		0.1
	)

func apply_movement(delta) -> void:
	var destination = player.global_position.direction_to(owner.position)*distance + player.global_position
	var velocity = owner.position.direction_to(destination)
	velocity *= min(owner.speed, owner.position.distance_to(destination)/delta/2.0)
	velocity += Vector2(0,dir).rotated($Detect.rotation) * owner.speed
	owner.move_and_slide(velocity)

func enter(_msg:={}):
	player = get_tree().get_nodes_in_group("player")[0]
	ray.position = Vector2.ZERO
	owner.path = []
	owner.detection.modulate = light
	owner.get_node("Sprite").modulate = colour
	AIServer.attacking.append(owner)
	owner.get_node("IndicatorSpawn").spawn("!")

func exit(): AIServer.attacking.erase(owner)

