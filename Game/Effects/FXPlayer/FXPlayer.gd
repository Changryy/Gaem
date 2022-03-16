extends Node

const WAVE = preload("res://Game/Effects/Shockwave/Shockwave.tscn")

signal shake_camera(duration, amount)
signal zoom_camera(new_zoom)
signal glow(duration, amount)

func shockwave(pos: Vector2, size: float = 1, duration: float = 0.5, power: float = 0.2):
	var new_wave = WAVE.instance()
	new_wave.position = pos
	new_wave.scale = Vector2.ONE * size
	new_wave.duration = duration
	new_wave.power = power
	add_child(new_wave)
	new_wave.start()


func glitch(duration: float, power: float = 0.01):
	$Overlay/Glitch.material.set_shader_param("shake_power", power)
	$Overlay/Glitch.material.set_shader_param("shake_rate", 1.0)
	yield(get_tree().create_timer(duration), "timeout")
	$Overlay/Glitch.material.set_shader_param("shake_rate", 0.0)

func shake(duration: float, amount = 1):
	if not amount is Vector2: amount *= Vector2.ONE
	emit_signal("shake_camera", duration, amount)

func zoom(new_zoom = 0):
	if not new_zoom is Vector2: new_zoom *= Vector2.ONE
	emit_signal("zoom_camera", new_zoom)

func glow(duration: float = 1, amount: float = 1):
	emit_signal("glow", duration, amount)
