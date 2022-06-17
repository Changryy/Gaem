extends State

export var glitch_time = 0.1
export var phase_time = 0.3
export var shake_time = 0.3
export var destination_cam = true


func enter(msg={}):
	var prev_pos = owner.position
	FXPlayer.glitch(glitch_time)
	yield(get_tree().create_timer(glitch_time),"timeout")
	
	FXPlayer.zoom(1.8)
	owner.get_node("Hitbox").disabled = true
	owner.get_node("Sprite").hide()
	owner.get_node("Trail").hide()
	owner.get_node("Floor").energy = 0
	owner.ui_animation.play("RESET")
	yield(VisualServer, "frame_post_draw")
	if destination_cam: owner.position = msg.position
	yield(get_tree().create_timer(phase_time),"timeout")
	if !destination_cam: owner.position = msg.position
	owner.get_node("Sprite").show()
	owner.get_node("Trail").show()
	owner.get_node("Floor").energy = 1.2
	owner.get_node("Hitbox").disabled = false
	generate_line(prev_pos, owner.position)
	FXPlayer.zoom(0.2)
	
	FXPlayer.shockwave(owner.position, 4)
	FXPlayer.shake(shake_time, 30)
	FXPlayer.glow(0.3, 0.1)
	
	yield(get_tree().create_timer(0.15),"timeout")
	owner.extend_ui()
	FXPlayer.zoom()
	if owner.reload: goto("Reload")
	else: goto("Normal")


func generate_line(from: Vector2, to: Vector2):
	var line = TempLine.new()
	line.set_as_toplevel(true)
	line.modulate = owner.modulate
	line.default_color = owner.get_node("Sprite").modulate
	line.width = owner.get_node("Trail").width
	line.width_curve = owner.get_node("Trail").width_curve
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.time = 1
	
	line.add_point(from)
	line.add_point(to)
	
	owner.add_child(line)
	








