extends State

func physics_update(_delta): owner.move()

func check():
	if Input.is_action_pressed("special"): goto("Slowmotion")

func update(delta):
	owner.regen(delta)
	owner.reload -= delta
	if owner.reload < 0:
		owner.reload = 0 
		goto("Normal")
