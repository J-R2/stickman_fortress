## The player character.  Stands tall on his fortress with guns and grenades held high.
extends Node2D

## Informs other nodes about the current amount of ammo and grenades the player has.
signal ammunition_counter(ammo:int, grenades:int)
## Informs other nodes about how many enemies the player has killed.
signal enemies_killed(count)


# The max ammo and grenades the player can hold. (Infinite reload of gun ammo.)
const MAX_AMMO = 30
const MAX_GRENADES = 3
const GRENADE = preload("res://scenes/grenade_scene/grenade.tscn")


## The pivot for where the player holds the gun, the gun rotates on this pivot to aim at enemies.
@onready var marker_gun_pivot: Marker2D = $MarkerGunPivot
## Plays the Banter voice lines.
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
## Players receive an additional grenade on timer timeout.
@onready var grenade_pickup_timer: Timer = $GrenadePickupTimer


## Current ammo count.  Set to MAX_AMMO on ready.
var ammo := 0
## Current grenade count.  Set to MAX_GRENADES on ready.
var grenades := 0


func _ready() -> void :
	ammo = MAX_AMMO
	grenades = MAX_GRENADES
	get_viewport().ready.connect(func() -> void: ammunition_counter.emit(ammo, grenades))
	get_tree().get_first_node_in_group("spawner").death_counter.connect(_on_enemy_killed)
	get_tree().get_first_node_in_group("menu").game_start.connect(func() -> void :ammunition_counter.emit(ammo, grenades))
	grenade_pickup_timer.timeout.connect(
		func() -> void :
			if grenades < MAX_GRENADES:
				grenades += 1
				ammunition_counter.emit(ammo, grenades)
	)

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
		launch_grenade((event as InputEventMouseButton).global_position)
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
		

## Makes an instance of a grenade and sets the grenade's target destination.
func launch_grenade(target_destination:Vector2) -> void :
	var grenade = GRENADE.instantiate()
	grenade.position = marker_gun_pivot.global_position
	add_child(grenade)
	grenade.initialize(target_destination)



func _on_enemy_killed(_count:int):
	enemies_killed.emit(_count)



