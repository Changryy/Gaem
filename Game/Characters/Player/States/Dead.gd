extends State

func enter(_msg={}):
	owner.dead = true
	owner.get_node("Hitbox").disabled = true
	owner.get_node("Sprite").hide()
	owner.get_node("Trail").hide()
	owner.ui_animation.play("RESET")
	
	var shatter = owner.get_node("Shatter") as CPUParticles2D
	shatter.emitting = true
	FXPlayer.shake(0.3, 10)
	yield(get_tree().create_timer(1.0), "timeout")
	FXPlayer.fade()
	yield(get_tree().create_timer(1.0), "timeout")
	get_node("/root/Game").respawn()

