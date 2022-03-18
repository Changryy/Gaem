extends ProgressBar


func _process(_delta):
	value = owner.health / owner.max_health
