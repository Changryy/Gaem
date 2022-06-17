tool
extends Line2D
class_name Wall

export var indestructible := false

func _ready():
	width = 30
	default_color = Color.white
	
	yield(get_tree(), "idle_frame")
	
	if Engine.editor_hint: return
	
	var node = PolyWall.new()
	node.indestructible = indestructible
	node.polygon = Geometry.offset_polyline_2d(
		points, width/2,
		Geometry.JOIN_MITER, Geometry.END_BUTT
	)[0]
	get_parent().add_child(node)
	queue_free()
