## The player character.  Stands tall on his fortress with guns and grenades held high.
extends Node2D

signal ammunition_counter(ammo:int, grenades:int)

const GRENADE = preload("res://scenes/grenade_scene/grenade.tscn")
# The max ammo and grenades the player can hold. (Infinite reload of gun ammo.)
const MAX_AMMO = 30
const MAX_GRENADES = 5

## The pivot for where the player holds the gun, the gun rotates on this pivot to aim at enemies.
@onready var marker_gun_pivot: Marker2D = $MarkerGunPivot

## Current ammo count.
var ammo := 30
## Current grenade count.
var grenades := 3



## Aim the gun towards the crosshair, only allow to aim towards right side of the screen.
## [br](The player scale's x axis is inverted in main scene.)
func _process(delta: float) -> void:
	marker_gun_pivot.look_at(get_global_mouse_position())
	marker_gun_pivot.rotation = clampf(marker_gun_pivot.rotation, -PI/2, PI/2)


func _unhandled_input(event: InputEvent) -> void:
	# ========================================== RIGHT CLICK
	var is_right_click = (
		event is InputEventMouseButton and
		event.is_pressed() and
		(event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT
	)
	# lower grenade count, emit new ammo count, instance a grenade and send it down range
	if is_right_click and grenades > 0:
		grenades -= 1
		ammunition_counter.emit(ammo, grenades)
		var grenade = GRENADE.instantiate()
		grenade.position = marker_gun_pivot.global_position
		add_child(grenade)
		grenade.initialize((event as InputEventMouseButton).global_position)
	# ========================================== LEFT CLICK
	var is_left_click : bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	# lower ammo count, emit new ammo count
	if is_left_click and ammo > 0:
		ammo -= 1
		ammunition_counter.emit(ammo, grenades)		
	# ========================================== RELOAD BUTTON
	var is_reload_button :bool = (
		event is InputEventKey and
		(event as InputEventKey).physical_keycode == KEY_R and
		event.is_pressed()
	)
	# reset ammo count and emit new ammo count
	if is_reload_button:
		ammo = MAX_AMMO
		ammunition_counter.emit(ammo, grenades)
		


