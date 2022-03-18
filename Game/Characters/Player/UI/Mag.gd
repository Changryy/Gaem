extends Label


func _process(_delta):
	text = str(stepify(owner.ammo, 0.1))
