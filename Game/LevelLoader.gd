extends Node

export var checkpoint := 0
var player_max_y := INF
var checkpoints = {}

var level_name = "Tutorial"

func respawn():
	var highest_point := INF
	for y in checkpoints:
		if y < player_max_y: continue
		elif y > highest_point: continue
		highest_point = y
		checkpoint = checkpoints[y]
	
	var level = get_tree().get_nodes_in_group("level")[0]
	level.queue_free()
	load_level()
	yield(VisualServer, "frame_post_draw")
	FXPlayer.fade(0, Color.transparent)


func reload(): get_tree().reload_current_scene()


func load_level():
	var level = load("res://Game/Levels/"+level_name+".tscn").instance()
	add_child(level)
