extends Position2D

const INDICATOR = preload("res://Game/Characters/Enemy/Indicator/Indicator.tscn")


func spawn(text):
	for c in get_children():
		if c.text == "!": return
	var node = INDICATOR.instance()
	node.text = text
	node.position = global_position
	node.set_as_toplevel(true)
	add_child(node)
	




