extends Node2D


func spawn_wall(polygon):
	var new_wall = PolyWall.new()
	new_wall.polygon = polygon
	add_child(new_wall)

