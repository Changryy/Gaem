extends State

func physics_update(_delta): owner.move()

func check():
	if Input.is_action_pressed("special"): goto("Slowmotion")
	if Input.is_action_pressed("reload"):
		owner.reload = owner.weapon.reload_time
		goto("Reload")

func update(delta):
	owner.regen(delta)
	if !Inventory.ability.shoot: return
	if Input.is_action_pressed("shoot"): owner.weapon.fire(delta)

