extends Area2D



func _on_Slowmotion_body_entered(body: PhysicsBody2D):
	if body.is_in_group("player") and !Inventory.ability.slowmotion:
		Inventory.ability.slowmotion = true
		body.ui_animation.play("ExtendUI_L")
