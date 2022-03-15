extends Camera2D

export(Vector2) var lookahead_multiplier := Vector2(1,2)

var is_shaking := false
var shake_amount := Vector2()
var lookahead := Vector2()

func _ready(): randomize()

func shake(duration: float, amount: Vector2):
	shake_amount = amount
	is_shaking = true
	yield(get_tree().create_timer(duration), "timeout")
	is_shaking = false
	offset = lookahead

func get_shake(): return Vector2(randf(), randf()) * shake_amount


func _process(_delta):
	lookahead = (get_viewport().get_mouse_position()
		- get_viewport_rect().size / 2) * lookahead_multiplier
	if is_shaking: offset = get_shake() + lookahead
	else: offset = lerp(offset, lookahead, 0.1)
