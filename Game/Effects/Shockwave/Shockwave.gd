extends Sprite

export(float, 0, 60, 0.1) var duration := 1.0
export(float, 0, 1, 0.01) var power := 0.1


func _ready():
	$Tween.connect("tween_all_completed", self, "queue_free")

func start():
	$Tween.interpolate_property(
		material, "shader_param/size",
		0.0, 0.5, duration, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		material, "shader_param/force",
		0.0, power, duration / 2,
		Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		material, "shader_param/force",
		power, 0.0, duration / 2,
		Tween.TRANS_QUAD, Tween.EASE_IN, duration / 2
	)
	$Tween.start()
