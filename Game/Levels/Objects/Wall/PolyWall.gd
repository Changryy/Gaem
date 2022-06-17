extends Polygon2D
class_name PolyWall


export var bitmask = 9
export var indestructible := false
export var min_area = 1.3 # devided by 2


func _ready():
	var body := StaticBody2D.new(); body.name = "body"
	var hitbox := CollisionPolygon2D.new(); hitbox.name = "hitbox"
	var occluder := LightOccluder2D.new(); occluder.name = "occluder"
	occluder.occluder = OccluderPolygon2D.new()
	
	occluder.light_mask = bitmask
	body.collision_layer = bitmask
	light_mask = bitmask
	antialiased = true
	
	body.add_child(hitbox); body.add_child(occluder)
	body.add_to_group("wall")
	add_child(body)
	
	update_shape()




func update_shape(new_polygon = polygon):
	call_deferred("set_polygon", new_polygon)
	get_node("body/hitbox").call_deferred("set_polygon", new_polygon)
	get_node("body/occluder").occluder.call_deferred("set_polygon", new_polygon)
	


func exclude_shape(poly: PoolVector2Array) -> bool:
	if indestructible: return false
	var result = Geometry.clip_polygons_2d(polygon, poly)
	if !result:
		queue_free()
		return true
	for i in len(result):
		if i == 0: continue
		if !Geometry.offset_polygon_2d(result[i], -min_area): continue
		get_parent().spawn_wall(result[i])
	if Geometry.offset_polygon_2d(result[0], -min_area): update_shape(result[0])
	else: queue_free()
	return true

