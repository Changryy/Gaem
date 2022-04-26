extends Camera2D

export(Vector2) var lookahead_multiplier := Vector2(0.5, 1)


var default_zoom = zoom
var target_zoom = zoom

var is_shaking := false
var shake_amount := Vector2()
var lookahead := Vector2()

func _ready():
	lookahead = Vector2.ZERO
	FXPlayer.connect("shake_camera", self, "shake")
	FXPlayer.connect("zoom_camera", self, "zoom_to")
	randomize()

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
	zoom = lerp(zoom, target_zoom + Vector2.ONE*lookahead.length()/900, 0.1)


func zoom_to(new_zoom):
	if new_zoom: target_zoom = new_zoom * default_zoom
	else: target_zoom = default_zoom
