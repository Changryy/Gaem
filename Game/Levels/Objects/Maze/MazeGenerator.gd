extends Node2D

const LINE = 30
const BIT := {
	Vector2.UP: 1,
	Vector2.RIGHT: 2,
	Vector2.DOWN: 4,
	Vector2.LEFT: 8
}

export var size := Vector2(50, 50)
export var pos := Vector2()
export var tile_size = 50
var map := []
var done := false

#    1
# 8  0  2
#    4

func _ready(): randomize()


# ---------- ADJACENT CHECKS ---------- #

func check_edge(directions:=[Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]):
	if Vector2.UP in directions and pos.y == 0: directions.erase(Vector2.UP)
	if Vector2.DOWN in directions and pos.y == (size.y-1): directions.erase(Vector2.DOWN)
	if Vector2.LEFT in directions and pos.x == 0: directions.erase(Vector2.LEFT)
	if Vector2.RIGHT in directions and pos.x == (size.x-1): directions.erase(Vector2.RIGHT)
	return directions

func check_availability(directions:=[Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]):
	directions = check_edge(directions)
	if Vector2.UP in directions and map[pos.y-1][pos.x] != null: directions.erase(Vector2.UP)
	if Vector2.DOWN in directions and map[pos.y+1][pos.x] != null: directions.erase(Vector2.DOWN)
	if Vector2.LEFT in directions and map[pos.y][pos.x-1] != null: directions.erase(Vector2.LEFT)
	if Vector2.RIGHT in directions and map[pos.y][pos.x+1] != null: directions.erase(Vector2.RIGHT)
	return directions

func find_last(directions:=[Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]):
	directions = check_edge(directions)
	if Vector2.UP in directions and map[pos.y-1][pos.x] & BIT[Vector2.DOWN]: return Vector2.UP
	if Vector2.DOWN in directions and map[pos.y+1][pos.x] & BIT[Vector2.UP]: return Vector2.DOWN
	if Vector2.LEFT in directions and map[pos.y][pos.x-1] & BIT[Vector2.RIGHT]: return Vector2.LEFT
	if Vector2.RIGHT in directions and map[pos.y][pos.x+1] & BIT[Vector2.LEFT]: return Vector2.RIGHT
	return null

# ---------- ADJACENT CHECKS ---------- #


func step():
	# Move back if stuck
	var available = check_availability()
	if !available: map[pos.y][pos.x] = 0
	while len(available) == 0:
		var last = find_last()
		if last == null:
			done = true
			return
		pos += last
		available = check_availability()
	# Continue to random tile
	var dir = available[randi() % available.size()]
	if map[pos.y][pos.x]: map[pos.y][pos.x] += BIT[dir]
	else: map[pos.y][pos.x] = BIT[dir]
	pos += dir

# generate empty map
func generate_map():
	for _y in size.y:
		var line := []
		for _x in size.x: line.append(null)
		map.append(line)

# Vector2( 10, 10 )+2

func create_tile(at) -> PoolVector2Array:
	var tile_pos = at * (LINE + tile_size)  + Vector2.ONE*LINE
	var tile_val = map[at.y][at.x]
	var tile: PoolVector2Array = [
		tile_pos,
		tile_pos + Vector2.RIGHT*tile_size,
		tile_pos + Vector2.ONE*tile_size,
		tile_pos + Vector2.DOWN*tile_size
	]
	var path: PoolVector2Array
	if tile_val & BIT[Vector2.UP]:
		path = [
			tile_pos + Vector2.UP*LINE,
			tile_pos + Vector2.UP*LINE + Vector2.RIGHT*tile_size,
			tile_pos + Vector2.RIGHT*tile_size,
			tile_pos
			
		]
		tile = Geometry.merge_polygons_2d(tile, path)[0]
	if tile_val & BIT[Vector2.DOWN]:
		path = [
			tile_pos + Vector2.DOWN*tile_size,
			tile_pos + Vector2.ONE*tile_size,
			tile_pos + Vector2.ONE*tile_size + Vector2.DOWN*LINE,
			tile_pos + Vector2.DOWN*(tile_size+LINE)
		]
		tile = Geometry.merge_polygons_2d(tile, path)[0]
	if tile_val & BIT[Vector2.LEFT]:
		path = [
			tile_pos + Vector2.LEFT*LINE,
			tile_pos,
			tile_pos + Vector2.DOWN*tile_size,
			tile_pos + Vector2.DOWN*tile_size + Vector2.LEFT*LINE
		]
		tile = Geometry.merge_polygons_2d(tile, path)[0]
	if tile_val & BIT[Vector2.RIGHT]:
		path = [
			tile_pos + Vector2.RIGHT*tile_size,
			tile_pos + Vector2.RIGHT*(tile_size+LINE),
			tile_pos + Vector2.ONE*tile_size + Vector2.RIGHT*LINE,
			tile_pos + Vector2.ONE*tile_size
		]
		tile = Geometry.merge_polygons_2d(tile, path)[0]
	return tile

func get_border(dir: Vector2) -> Vector2:
	return dir * size.x * (tile_size + LINE) + dir * LINE

# Merges inner and outer polygons into 1 shape
# (Doesnt work)
func safe_poly(polys: Array) -> PoolVector2Array:
	var result: PoolVector2Array = []
	for p in polys:
		result.append_array(p)
	polys.invert()
	for p in polys:
		if !Geometry.is_polygon_clockwise(p): p.invert()
		result.append(p[0])
	return result

func create_walls():
	for y in size.y:
		for x in size.x:
			var p = Polygon2D.new()
			p.set_polygon(create_tile(Vector2(x,y)))
			add_child(p)

func start():
	map = []
	pos = size/2
	done = false
	generate_map()
	while !done: step()
	create_walls()


func _process(_delta):
	if Input.is_action_just_released("dash"):
		for c in get_children():
			if not c is Camera2D: c.queue_free()
		start()











