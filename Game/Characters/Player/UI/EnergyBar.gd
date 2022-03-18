extends ProgressBar

func _process(_delta):
	value = owner.energy / owner.max_energy
