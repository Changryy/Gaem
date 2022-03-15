extends State

func physics_update(_delta): owner.move()

func handle_input(_event):
	if Input.is_action_just_released("special"): goto("Slowmotion")
