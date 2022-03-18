extends Line2D
class_name TempLine

export(float) var time
onready var max_width := width


func _process(delta):
	width -= max_width/time * delta
	if width <= 0: queue_free()
