
extends Label

func _process(_delta):
	if Inventory.ammo < 1000:
		text = str(Inventory.ammo)
	else:
		text = "999"



