extends State

export var colour := Color.white
onready var lazer = owner.get_node("Lazer")

func physics_update(delta):
	lazer.scan(delta)

func _on_Lazer_found(pos):
	if AIServer.is_full(): return
	goto("Search", {search=pos,direction=Vector2.ZERO})

func enter(_msg:={}):
	owner.detection.hide()
	lazer.enabled = true
	lazer.show()
	owner.get_node("Sprite").modulate = colour

func exit():
	lazer.enabled = false
	lazer.hide()
