extends State

export(float) var time_scale = 0.3
export(float, 0, 60, 0.1) var duration = 1
export(float, 0, 60, 0.1) var transition = 0.7

var wait_time := 0.0

func update(delta):
	wait_time += delta
	if wait_time > duration: goto("Normal")

func physics_update(_delta): owner.move()


func interpolate(to, easing := Tween.EASE_OUT):
	$Tween.interpolate_property(
		Engine, "time_scale",
		Engine.time_scale, to, transition,
		Tween.TRANS_CUBIC, easing
	); $Tween.start()

func enter(_msg={}):
	wait_time = 0
	interpolate(time_scale)

func exit(): interpolate(1.0, Tween.EASE_IN)

func handle_input(_event):
	if Input.is_action_just_released("special") \
		and wait_time != 0: goto("Normal")
	if Input.is_action_just_pressed("shoot"): pass
	if Input.is_action_just_pressed("reload"): pass

