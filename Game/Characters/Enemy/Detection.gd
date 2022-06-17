tool
extends Polygon2D

const RAY_COLLISION := 10
signal found()
signal lost()

var is_tracking := false

export(int) var distance = 500 setget set_distance
export(float) var angle = 30 setget set_angle
export(float) var precision = 0.5 setget set_precision

func set_distance(x):
	distance = x; generate()
func set_angle(x):
	angle = x; generate()
func set_precision(x):
	precision = x; generate()

func generate():
	yield(self, "ready")
	for c in get_children():
		if c is RayCast2D: c.queue_free()
	var polygon: PoolVector2Array = []
	for i in int(angle*precision*2):
		var rot = deg2rad(i / precision - angle)
		polygon.append(Vector2(distance,0).rotated(rot))
		create_ray(rot)
	polygon.append(Vector2(distance,0).rotated(deg2rad(angle)))
	create_ray(deg2rad(angle))
	polygon.append(Vector2.ZERO)
	set_polygon(polygon)
	set_uv(polygon)

func sort_rays(a, b): return a.rotation < b.rotation

func create_ray(rot=0.0):
	var ray = RayCast2D.new()
	ray.enabled = true
	ray.collision_mask = RAY_COLLISION
	ray.cast_to = Vector2(distance,0)
	ray.rotate(rot)
	add_child(ray)
	ray.hide()
	return ray

func _ready():
	if !Engine.editor_hint: hide()

# checks if x is between a and b
func is_between(x: Vector2, a: Vector2, b: Vector2) -> bool:
	var dir_a = a.direction_to(b)
	var dir_b = x.direction_to(b)
	return dir_a.distance_to(dir_b) < 0.001

func _physics_process(_delta):
	if !visible or Engine.editor_hint: return
	var poly  = []
	var player_spotters = []
	for ray in get_children():
		if not ray is RayCast2D: continue
		ray.force_raycast_update()
		if ray.is_colliding():
			if ray.get_collider().is_in_group("player"):
				player_spotters.append(ray)
				poly.append(Vector2(distance,0).rotated(ray.rotation))
			else:
				poly.append((ray.get_collision_point()-global_position).rotated(-global_rotation))
		else: poly.append(Vector2(distance,0).rotated(ray.rotation))
	poly.append(Vector2.ZERO)
	var useless_vertecies: PoolVector2Array = []
	for i in range(1, len(poly)-1):
		if poly[i-1].distance_to(poly[i+1]) > 30: continue
		if is_between(poly[i], poly[i-1], poly[i+1]):
			useless_vertecies.append(poly[i])
	for x in useless_vertecies: poly.erase(x)
	set_polygon(poly)
	set_uv(poly)
	
	if player_spotters:
		is_tracking = true
		emit_signal("found")
		return
	if !is_tracking: return
	is_tracking = false
	emit_signal("lost")
	return

func reset():
	var poly: PoolVector2Array = []
	for ray in get_children():
		if not ray is RayCast2D: continue
		poly.append(Vector2(distance,0).rotated(ray.rotation))
	poly.append(Vector2.ZERO)
	set_uv(poly)
	set_polygon(poly)
	return self


# Vector2(73.741,-41.297)

# Vector2(72.467, -41.419)
# Vector2(73.1, -41.358)

# Vector2( 0.995446, 0.095324 ).distance_to(Vector2( 0.995502, 0.0947372 ))
# 0.000589463
# 1.0
# 0.1
# Vector2( 0.995502, 0.0947372 )





