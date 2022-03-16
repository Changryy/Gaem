extends State

export var glitch_time = 0.08
export var phase_time = 0.3
export var shake_time = 0.3
export var destination_cam = false


func enter(msg={}):
	FXPlayer.glitch(glitch_time)
	yield(get_tree().create_timer(glitch_time),"timeout")
	
	FXPlayer.zoom(1.8)
	owner.hide()
	if destination_cam: owner.position = msg.position
	yield(get_tree().create_timer(phase_time),"timeout")
	if !destination_cam: owner.position = msg.position
	owner.show()
	FXPlayer.zoom(0.2)
	
	FXPlayer.shockwave(owner.position, 4)
	FXPlayer.shake(shake_time, 30)
	FXPlayer.glow(0.3, 0.1)
	
	yield(get_tree().create_timer(0.15),"timeout")
	FXPlayer.zoom()
	if owner.reload: goto("Reload")
	else: goto("Normal")
