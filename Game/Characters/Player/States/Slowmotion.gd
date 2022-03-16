extends State

export(Curve) var curve: Curve

var wait_time := 0.0
var duration := 0.0

func update(delta):
	Engine.time_scale = curve.interpolate(wait_time/duration)
	if wait_time > duration:
		if owner.reload: goto("Reload")
		else: goto("Normal")
	wait_time += delta / Engine.time_scale
	if Input.is_action_pressed("special"):
		owner.energy -= (delta / Engine.time_scale)

func physics_update(_delta): owner.move()
func enter(_msg={}):
	wait_time = 0
	duration = owner.energy
func exit(): Engine.time_scale = 1

func check():
	if Input.is_action_just_released("special"):
		wait_time = find_last_x(Engine.time_scale) * duration
	if Input.is_action_just_pressed("shoot") and owner.energy > owner.teleport_cost:
		owner.energy -= owner.teleport_cost
		goto("Teleport", {position=owner.get_global_mouse_position()})
	if Input.is_action_just_pressed("reload"): pass


func find_last_x(y, precision := 0.0001):
	var x := 1.0
	while curve.interpolate(x) > y:
		x -= precision
	return x
