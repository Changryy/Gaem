extends State


export(NodePath) onready var camera = get_node(camera) as Camera2D


func _ready():
	camera.set_process(false)
	owner.connect("input_event", self, "input_event")



func input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if state_machine.state != self: return
	if (event is InputEventMouseButton
	and event.button_index == BUTTON_LEFT
	and event.is_pressed()):
		turn_on()



func turn_on():
	camera.set_process(true)
	owner.ui_animation.play("On")
	yield(get_tree().create_timer(1), "timeout")
	owner.ui_animation.play("ExtendUI")
	goto("Normal")
