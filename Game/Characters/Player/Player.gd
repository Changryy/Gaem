extends KinematicBody2D

export(int) var speed = 600
export(float) var max_energy = 2
export(float) var energy_regen := 0.5
export(float) var teleport_cost := 1.0
export(Resource) onready var weapon = weapon as Weapon
export(int) var max_health = 100
export(NodePath) onready var ui_animation = get_node(ui_animation) as AnimationPlayer

var velocity := Vector2()
var reload: float = 0
var energy: float = max_energy
var ammo: int = 0
var health := 100




# ---------- CROSS-STATE FUNCTIONS ---------- #

func check(action): return Input.is_action_pressed("move_"+action)
func get_move_dir():
	var dir = Vector2()
	if check("down"): dir.y += 1
	if check("up"): dir.y -= 1
	if check("right"): dir.x += 1
	if check("left"): dir.x -= 1
	return dir.normalized()


# movement
func move():
	velocity = lerp(
		velocity,
		get_move_dir() * speed,
		0.2
	)
	velocity = move_and_slide(velocity)


# energy regen
func regen(delta, multiplier := 1.0):
	if energy < 0: energy = 0
	if energy < max_energy: energy += energy_regen * delta * multiplier


# reload x amount of ammo
func refill(amount = weapon.mag_size - ammo):
	match weapon.ammo_type:
		Weapon.AMMO.energy: pass
		Weapon.AMMO.normal:
			amount = clamp(amount, 0, Inventory.ammo)
			Inventory.ammo -= amount
			ammo += amount

func check_tp(tp_pos) -> bool:
	if energy < teleport_cost: return false
	$Ray.cast_to = tp_pos - position
	$Ray.force_raycast_update()
	return !$Ray.is_colliding()

# ---------- CROSS-STATE FUNCTIONS ---------- #



func _ready():
	ui_animation.play("RESET")
	ui_animation.play("Off")
	weapon.owner = self











