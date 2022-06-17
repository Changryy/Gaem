extends Area2D





func _on_Teleport_body_entered(body):
	if body.is_in_group("player") and !Inventory.ability.shoot:
		Inventory.ability.shoot = true
		body.ui_animation.play("ExtendUI_R")
