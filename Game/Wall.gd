extends Polygon2D
class_name Wall

export var bitmask = 9


func _ready():
	
	var body := StaticBody2D.new(); body.name = "body"
	var hitbox := CollisionPolygon2D.new(); hitbox.name = "hitbox"
	var occluder := LightOccluder2D.new(); occluder.name = "occluder"
	occluder.occluder = OccluderPolygon2D.new()
	
	occluder.light_mask = bitmask
	body.collision_layer = bitmask
	light_mask = bitmask
	
	body.add_child(hitbox); body.add_child(occluder)
	add_child(body)
	
	update_shape()



func update_shape(new_polygon: PoolVector2Array = polygon):
	polygon = new_polygon
	get_node("body/hitbox").polygon = new_polygon
	get_node("body/occluder").occluder.polygon = new_polygon



