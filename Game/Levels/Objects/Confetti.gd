extends CPUParticles2D

var activated := false


func activate(body: PhysicsBody2D):
	if !body.is_in_group("player") or activated: return
	activated = true
	emitting = true


