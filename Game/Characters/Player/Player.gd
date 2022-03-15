extends KinematicBody2D


export var speed = 4000
var velocity := Vector2()



func check(action): return Input.is_action_pressed("move_"+action)
func get_move_dir():
	var dir = Vector2()
	if check("down"): dir.y += 1
	if check("up"): dir.y -= 1
	if check("right"): dir.x += 1
	if check("left"): dir.x -= 1
	return dir.normalized()

func _ready():
	FXPlayer.connect("shake_camera", $Camera, "shake")
	yield(get_tree().create_timer(0.2),"timeout")
	FXPlayer.glitch(0.1)
	yield(get_tree().create_timer(0.8),"timeout")
	FXPlayer.shockwave(position)
	FXPlayer.shake(0.3)


func _physics_process(_delta):
	velocity = lerp(
		velocity,
		get_move_dir() * speed,
		0.2
	)
	velocity = move_and_slide(velocity)
