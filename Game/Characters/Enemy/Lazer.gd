extends RayCast2D
signal found(pos)

export(float) var deg_per_second = 45

var is_ready := false

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	is_ready = true

func scan(delta):
	if !is_ready: return
	rotate(deg2rad(deg_per_second)*delta)
	if !is_colliding():
		$Line.points = [Vector2(25,0), cast_to]
		return
	
	var point = get_collision_point()
	var dist = (point-global_position).length()
	
	$Line.material.set_shader_param("len", dist)
	$Line.points = [Vector2(25,0), Vector2(dist,0)]
	
	if get_collider().is_in_group("player"):
		emit_signal("found", point)
