extends Area2D



func _on_Teleport_body_entered(body):
	if body.is_in_group("player") and !Inventory.ability.teleport:
		Inventory.tp_checkpoint = true
