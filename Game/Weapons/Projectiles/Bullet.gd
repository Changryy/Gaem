extends Node2D

export var is_enemy := false

var speed := 5000
var spread := 1.0
var damage := 1

var dead := false
var target


func _ready():
	set_as_toplevel(true)
	$Trail.set_as_toplevel(true)
	$Trail.add_point(global_position)
	if !is_enemy: look_at(get_global_mouse_position())
	randomize()
	rotation_degrees += rand_range(-spread, spread)


func _physics_process(delta):
	if dead:
		if $Trail.width > 0.3: $Trail.width = lerp($Trail.width, 0, 0.3)
		else:
			$Trail.width = 0
			if not ($Particles.emitting or $Spark.emitting):
				queue_free()
	else: move(delta)
	

func move(delta):
	var velocity = Vector2.RIGHT * speed * delta
	translate(velocity.rotated(rotation))
	
	$Ray.position = -velocity
	$Ray.cast_to = velocity
	$Ray.force_raycast_update()
	if $Ray.is_colliding(): return die()
	
	$Trail.add_point(global_position)
	
	if $Trail.points[0].distance_to($Trail.points[-1]) > speed * 0.1:
		$Trail.remove_point(0)

func die():
	dead = true
	target = $Ray.get_collider() as CollisionObject2D
	if !target: return queue_free()
	elif target.is_in_group("wall"): hit_wall(target.get_parent())
	elif target.is_in_group("character"): hit_character()
	elif target.is_in_group("box"): hit_box()
	$Trail.add_point($Ray.get_collision_point())

func hit_wall(wall):
	var pos = $Ray.get_collision_point()
	var shape = PoolVector2Array()
	for vertex in $Poly.polygon:
		shape.append(pos + wall.position + vertex.rotated(rotation))
	if wall.exclude_shape(shape):
		$Particles.global_position = pos
		$Particles.emitting = true
	else:
		$Spark.global_position = pos
		$Spark.emitting = true

func hit_box():
	$Spark.global_position = $Ray.get_collision_point()
	$Spark.emitting = true
	target.apply_impulse(
		$Ray.get_collision_point() - target.global_position,
		-$Ray.get_collision_normal() * 4000
	)


func hit_character():
	if !target: return
	target.dmg(damage)
	target = null
	#queue_free()
