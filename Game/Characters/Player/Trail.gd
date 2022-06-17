extends Line2D

export(int) var length


func _ready():
	set_as_toplevel(true)
	owner.connect("hide", self, "clear_points")

func _process(_delta):
	default_color = owner.get_node("Sprite").modulate
	if !owner.visible: return 
	add_point(owner.position)
	#if Engine.time_scale != 1.0: return
	for _i in 2: if len(points) > length/Engine.time_scale: remove_point(0)


