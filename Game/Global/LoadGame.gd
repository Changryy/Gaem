extends Node


func _ready():
	OS.window_size = OS.window_size * OS.get_screen_scale()
	OS.window_position = OS.get_screen_size()*0.5 - OS.window_size*0.5
