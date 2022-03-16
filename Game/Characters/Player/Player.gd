extends KinematicBody2D

export(int) var speed = 600
export(float) var max_energy = 2
export(float) var energy_regen := 0.5
export(float) var teleport_cost := 1.0


var velocity := Vector2()
var reload: float = 0
var energy: float = max_energy

func check(action): return Input.is_action_pressed("move_"+action)
func get_move_dir():
	var dir = Vector2()
	if check("down"): dir.y += 1
	if check("up"): dir.y -= 1
	if check("right"): dir.x += 1
	if check("left"): dir.x -= 1
	return dir.normalized()

func move():
	velocity = lerp(
		velocity,
		get_move_dir() * speed,
		0.2
	)
	velocity = move_and_slide(velocity)

func _process(_delta):
	$EnergyBar.value = energy / max_energy

func regen(delta, multiplier := 1.0):
	if energy < 0: energy = 0
	if energy < max_energy: energy += energy_regen * delta * multiplier
