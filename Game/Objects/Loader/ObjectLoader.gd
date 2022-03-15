extends Node


func spawn_wall(polygon, col):
	var new_wall = Wall.new()
	new_wall.polygon = polygon
	new_wall.color = col
	add_child(new_wall)

