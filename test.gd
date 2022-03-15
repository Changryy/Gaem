extends Area2D



func _ready():
	connect("body_entered", self, "check")
	yield(get_tree().create_timer(2), "timeout")
	translate(Vector2(0,1))



func check(body):
	body.get_parent().exclude_shape($Hitbox.polygon)
	queue_free()
