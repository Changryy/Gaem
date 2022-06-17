extends Resource
class_name Weapon

const BULLET := preload("res://Game/Weapons/Projectiles/Bullet.tscn")


enum AMMO {
	normal,
	energy
}

enum RELOAD {
	mag, # Fully reload when reload timer reaches 0
	rounds, # Reload one and one round
	charge # Charge energy
}

enum FIRE {
	single,
	auto,
	beam
}


export(float) var damage
export(float) var rps

export(AMMO) var ammo_type
export(int) var mag_size

export(FIRE) var fire_type
export(float) var consumption # energy consumption per round
export(PackedScene) var beam

export(RELOAD) var reload_type
export(float) var reload_time

export(GDScript) var custom_behaviour

var time: float = 0
var owner: KinematicBody2D

# Returns true if succesful
func fire(delta) -> bool:
	if owner.ammo <= 0: return false
	match fire_type:
		FIRE.beam:
			owner.ammo -= delta * consumption
		_:
			if (OS.get_ticks_usec() - time) < (1000000 / rps): return false
			time = OS.get_ticks_usec()
			_fire_round()
	return true

func _fire_round():
	owner.ammo -= 1
	var bullet = BULLET.instance()
	bullet.position = owner.position
	bullet.damage = damage
	owner.add_child(bullet)







