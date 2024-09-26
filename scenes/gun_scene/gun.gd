extends Node2D

const BULLET = preload("res://scenes/bullet_scene/bullet.tscn")  ## The bullet scene. Instanced on left_click if ammo is available.
const MAX_AMMO = 30 ## The max ammo, for resetting after reload.


@onready var muzzle: Marker2D = $Muzzle  ## Position of the gun's muzzle tip, for positioning instanced bullets.
@onready var animation_player: AnimationPlayer = $AnimationPlayer  ## Has a "reload" animation


## The current ammo count.
var ammo :int = 30


## Handles input and logic for shooting and reloading.
func _unhandled_input(event: InputEvent) -> void:
	var is_left_click : bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	# Shoot if left click and there is available ammo.
	if is_left_click and ammo > 0:
		shoot()
		ammo -= 1 # bullet is no longer in the mag.
	
	var is_reload_button :bool = (
		event is InputEventKey and
		(event as InputEventKey).physical_keycode == KEY_R and
		event.is_pressed()
	)
	# Reload if you press R
	if is_reload_button:
		reload()


## Plays the reload animation and resets the ammo count, reset the gun animation just in case
func reload() -> void:
	animation_player.play("reload")
	await animation_player.animation_finished
	ammo = MAX_AMMO
	animation_player.play("RESET")


## Instance a bullet on the muzzle tip.
func shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_rotation = global_rotation
	bullet.global_position = muzzle.global_position
	muzzle.add_child(bullet)
