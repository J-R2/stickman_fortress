extends Node2D

@onready var muzzle: Marker2D = $Muzzle

const BULLET = preload("res://scenes/bullet_scene/bullet.tscn")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()



func shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_rotation = global_rotation
	bullet.global_position = muzzle.global_position
	muzzle.add_child(bullet)
