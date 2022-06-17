extends ProgressBar

func _ready():
	max_value = owner.max_health

func _process(_delta):
	value = owner.health
