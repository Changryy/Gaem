extends Node2D

var line_arc = 8

func draw_cool_thing(r, col):
	for i in 16:
		var start = (i/16.0 * 360) - line_arc/2
		var stop = (i/16.0 * 360) + line_arc/2
		draw_arc(
			Vector2(), r,
			deg2rad(start), deg2rad(stop), 10,
			col, 5
		)

func _draw():
	draw_cool_thing(300, Color(1,1,1))
	draw_cool_thing(600, Color(0.3,0.3,0.3))

