extends Polygon2D
class_name PolyWall


export var bitmask = 9


func _ready():
	var body := StaticBody2D.new(); body.name = "body"
	var hitbox := CollisionPolygon2D.new(); hitbox.name = "hitbox"
	var occluder := LightOccluder2D.new(); occluder.name = "occluder"
	occluder.occluder = OccluderPolygon2D.new()
	
	occluder.light_mask = bitmask
	body.collision_layer = bitmask
	light_mask = bitmask
	antialiased = true
	body.add_to_group("wall")
	
	body.add_child(hitbox); body.add_child(occluder)
	add_child(body)
	
	update_shape()





func update_shape(new_polygon = polygon):
	call_deferred("set_polygon", new_polygon)
	get_node("body/hitbox").call_deferred("set_polygon", new_polygon)
	get_node("body/occluder").occluder.call_deferred("set_polygon", new_polygon)


func exclude_shape(poly: PoolVector2Array):
	var result = Geometry.clip_polygons_2d(polygon, poly)
	if !result: return queue_free()
	update_shape(result.pop_front())
	for shape in result:
		get_parent().spawn_wall(shape)

