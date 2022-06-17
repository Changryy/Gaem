extends Position2D
class_name BulletSpawner

const BULLET := preload("res://Game/Weapons/Projectiles/Bullet.tscn")

export var time := Vector2(0.1,1)


func _ready():
	yield(get_tree().create_timer(rand_range(0,time.y)), "timeout")
	fire()


func fire():
	var bullet = BULLET.instance()
	bullet.is_enemy = true
	bullet.position = position
	bullet.rotation = rotation
	bullet.damage = 60
	add_child(bullet)
	get_tree().create_timer(rand_range(time.x,time.y)).connect("timeout", self, "fire")

