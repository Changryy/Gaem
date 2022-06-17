	extends Position2D

const PLAYER = preload("res://Game/Characters/Player/Player.tscn")

export var abilities = {
	slowmotion = true,
	teleport = true,
	shoot = true
}
export var disable := false

func _ready():
	if disable:
		queue_free()
		return
	var game = get_node("/root/Game")
	game.checkpoints[global_position.y] = get_index()
	if game.checkpoint != get_index(): return queue_free()
	yield(get_parent(), "ready")
	Inventory.ability = abilities
	var p = PLAYER.instance()
	p.position = position
	get_parent().add_child(p)
	queue_free()
 
