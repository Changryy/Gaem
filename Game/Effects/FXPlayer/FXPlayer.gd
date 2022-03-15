extends Node

const WAVE = preload("res://Game/Effects/Shockwave/Shockwave.tscn")

signal shake_camera(duration, amount)


func shockwave(pos: Vector2, size: float = 16, duration: float = 0.5, power: float = 0.2):
	var new_wave = WAVE.instance()
	new_wave.position = pos
	new_wave.scale = Vector2(1,1) * size
	new_wave.duration = duration
	new_wave.power = power
	add_child(new_wave)
	new_wave.start()


func glitch(duration: float, power: float = 0.01):
	$Overlay/Glitch.material.set_shader_param("shake_power", power)
	$Overlay/Glitch.material.set_shader_param("shake_rate", 1.0)
	yield(get_tree().create_timer(duration), "timeout")
	$Overlay/Glitch.material.set_shader_param("shake_rate", 0.0)

func shake(duration: float, amount: Vector2 = Vector2(150,150)):
	emit_signal("shake_camera", duration, amount)
