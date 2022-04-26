extends Node2D

var speed := 5000
var spread := 1.0

var dead := false


func _ready():
	set_as_toplevel(true)
	$Trail.set_as_toplevel(true)
	look_at(get_global_mouse_position())
	randomize()
	rotation_degrees += rand_range(-spread, spread)


func _physics_process(delta):
	if dead:
		if $Trail.width > 0.3: $Trail.width = lerp($Trail.width, 0, 0.3)
		else: $Trail.width = 0
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
	var target = $Ray.get_collider() as CollisionObject2D
	if target.is_in_group("wall"): hit_wall(target.get_parent())
	$Trail.add_point($Ray.get_collision_point())

func hit_wall(wall):
	var pos = $Ray.get_collision_point()
	var shape = PoolVector2Array()
	for vertex in $Poly.polygon:
		shape.append(pos + wall.position + vertex.rotated(rotation))
	wall.exclude_shape(shape)
	particles(pos)


func particles(pos):
	$Particles.global_position = pos
	$Particles.emitting = true
	yield(get_tree().create_timer($Particles.lifetime), "timeout")
	queue_free()

