extends Resource
class_name Weapon

enum AMMO_TYPE {
	low_cal,
	high_cal,
	energy,
	shell,
	rocket
}

enum RELOAD {
	mag, # Fully reload when reload timer reaches 0
	rounds, # Reload one and one round
	charge # Charge energy
}


export(float) var damage
export(int) var mag_size
export(float) var rps
export(float) var reload_time
export(AMMO_TYPE) var ammo
export(RELOAD) var reload_type
export(float) var consumption # energy consumption per round
export(bool) var is_timed = false
#export(bool) var is_timed = false
export(GDScript) var behaviour


func fire(_delta) -> float:
	return 1.0

