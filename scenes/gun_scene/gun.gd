extends Node2D

@onready var muzzle: Marker2D = $Muzzle

const BULLET = preload("res://scenes/bullet_scene/bullet.tscn")



func _unhandled_input(event: InputEvent) -> void:
	var is_left_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	if is_left_click:
		shoot()
	

		


func shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_rotation = global_rotation
	bullet.global_position = muzzle.global_position
	muzzle.add_child(bullet)
