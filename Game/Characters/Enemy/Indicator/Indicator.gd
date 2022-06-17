extends Node2D

var text := "n"

const TIME = 0.5

func _ready():
	randomize()
	set_as_toplevel(true)
	if text == "n":
		$Nope.show()
		$Label.text = ""
	else:
		$Nope.hide()
		$Label.text = text
	
	$Tween.interpolate_property(
		self, "scale", scale, Vector2.ZERO,
		TIME, Tween.TRANS_BACK, Tween.EASE_IN
	)
	$Tween.interpolate_property(
		self, "rotation", 0, rand_range(-PI/2.0, PI/2.0),
		TIME, Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.interpolate_property(
		self, "position", position,
		position + Vector2(rand_range(-20, 20), rand_range(-20, 0)),
		TIME, Tween.TRANS_QUAD, Tween.EASE_IN
	)
	$Tween.start()

func done(): queue_free()
