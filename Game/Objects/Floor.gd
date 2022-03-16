tool
extends Polygon2D
class_name Floor

export var bitmask = 17


func _ready():
	if Engine.editor_hint:
		z_index = -10
		color = Color("202020")
		light_mask = bitmask
		return
	var body := StaticBody2D.new(); body.name = "body"
	var hitbox := CollisionPolygon2D.new(); hitbox.name = "hitbox"
	
	body.collision_layer = bitmask
	hitbox.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
	
	body.add_child(hitbox);
	add_child(body)
	
	update_shape()



func update_shape(new_polygon = polygon):
	call_deferred("set_polygon", new_polygon)
	get_node("body/hitbox").call_deferred("set_polygon", new_polygon)


