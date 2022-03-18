extends State

func physics_update(_delta): owner.move()

func check():
	if Input.is_action_pressed("special"): goto("Slowmotion")
	if Input.is_action_pressed("shoot"): goto("Normal")

func get_progress(as_float := false):
	var progress = (owner.weapon.reload_time - owner.reload) / owner.weapon.reload_time
	progress *= owner.weapon.mag_size
	if !as_float: return floor(progress)
	return progress

func update(delta):
	owner.regen(delta)
	owner.reload -= delta
	
	match owner.weapon.reload_type:
		Weapon.RELOAD.rounds: owner.refill(get_progress())
		Weapon.RELOAD.charge: owner.refill(get_progress(true))
	
	if owner.reload < 0:
		owner.reload = 0
		owner.refill()
		goto("Normal")
