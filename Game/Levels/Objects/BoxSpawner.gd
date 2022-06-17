extends Node2D

const BOX = preload("res://Game/Levels/Objects/Box.tscn")
const SIZE = 10

var activated := false

func _ready():
	for x in abs($start.position.x - $stop.position.x) / SIZE:
		for y in abs($start.position.y - $stop.position.y) / SIZE:
			var box = BOX.instance()
			box.position.x = min($start.position.x, $stop.position.x) + x * SIZE
			box.position.y = min($start.position.y, $stop.position.y) + y * SIZE
			add_child(box)


func activate(body: PhysicsBody2D):
	if !body.is_in_group("player") or activated: return
	activated = true
	$Tween.interpolate_property(
		$ball, "position", $ball.position,
		$ball.position + Vector2.UP*500, 0.5
	)
	$Tween.start()

func done():
	$ball.queue_free()

