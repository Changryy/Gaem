extends KinematicBody2D

export(int) var speed = 600
export(float) var max_energy = 2
export(float) var energy_regen := 0.5
export(float) var teleport_cost := 1.0
export(Resource) onready var weapon = weapon as Weapon
export(int) var max_health: float = 100
export(NodePath) onready var ui_animation = get_node(ui_animation) as AnimationPlayer

var velocity := Vector2()
var reload: float = 0
onready var energy: float = max_energy
var ammo: int = 0
onready var health: float = max_health
onready var game = get_node("/root/Game")

var dead := false
var can_heal := true
onready var default_col: Color = $Sprite.modulate
var best_distance := 0.0

const INDICATOR = preload("res://Game/Characters/Enemy/Indicator/Indicator.tscn")


# ---------- CROSS-STATE FUNCTIONS ---------- #
func player_time_scale():
	return lerp(1, Engine.time_scale, 0.9)
# movement
func move():
	velocity = lerp(
		velocity,
		Input.get_vector("move_left", "move_right", "move_up", "move_down")
		* speed / player_time_scale(),
		0.2
	)
	$Camera.smoothing_speed = 8 / player_time_scale()
	velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, 0, false)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is RigidBody2D:
			collision.collider.apply_impulse(
				collision.position - collision.collider.global_position,
				-collision.normal * 1000
			)


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

func extend_ui():
	if dead: return
	if Inventory.ability.shoot:
		ui_animation.play("ExtendUI")
	elif Inventory.ability.slowmotion:
		ui_animation.play("ExtendUI_L")

# ---------- CROSS-STATE FUNCTIONS ---------- #




# ---------- HEALTH ---------- #

func dmg(amount):
	can_heal = false
	health -= amount
	if health <= 0.0: die()
	$Sprite.modulate = Color(1.7,0.7,0.7)
	get_tree().create_timer(1.0).connect("timeout", self, "_start_healing")
	yield(get_tree().create_timer(0.1), "timeout")
	$Sprite.modulate = default_col
	$Trail.default_color = default_col

func _start_healing(): can_heal = true

func die():
	if dead: return
	$StateMachine.transition_to("Dead", {})


# ---------- HEALTH ---------- #





func _ready():
	ui_animation.play("RESET")
	ui_animation.play("Off")
	weapon.owner = self
	refill()


func _physics_process(delta):
	var sum = 0
	for ray in $Detection.get_children():
		if ray.is_colliding():
			sum += global_position.distance_squared_to(ray.get_collision_point())
		else: sum += 490000
	best_distance = sqrt(sum / 45) - 25
	
	if game: game.player_max_y = min(game.player_max_y, global_position.y)
	if can_heal and health < max_health:
		health += delta * 10









