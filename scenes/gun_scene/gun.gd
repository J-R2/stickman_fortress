extends Node2D

const BULLET = preload("res://scenes/bullet_scene/bullet.tscn")  ## The bullet scene. Instanced on left_click if ammo is available.

const SINGLE_SHOT_SOUND = preload("res://scenes/gun_scene/sounds/single_fire_762.wav")
const OUT_OF_AMMO_SOUND = preload("res://scenes/gun_scene/sounds/outofammo.ogg")

@onready var muzzle: Marker2D = $Muzzle  ## Position of the gun's muzzle tip, for positioning instanced bullets.
@onready var animation_player: AnimationPlayer = $AnimationPlayer  ## Has a "reload" animation
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## The current ammo count.
var ammo :int = 0
var is_reloading = false


func _ready() -> void:
	get_tree().get_first_node_in_group("player").ammunition_counter.connect(_update_ammo)


## Handles input and logic for shooting and reloading.
func _unhandled_input(event: InputEvent) -> void:
	var is_left_click : bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	# Shoot if left click and there is available ammo.
	if is_left_click and ammo > 0 and !is_reloading:
		shoot()
	if is_left_click and ammo < 1:
		audio_stream_player_2d.stream = OUT_OF_AMMO_SOUND
		audio_stream_player_2d.play()
	
	
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
	is_reloading = true
	await animation_player.animation_finished
	animation_player.play("RESET")
	is_reloading = false


## Instance a bullet on the muzzle tip.
func shoot() -> void:
	audio_stream_player_2d.stream = SINGLE_SHOT_SOUND
	var bullet = BULLET.instantiate()
	bullet.global_rotation = global_rotation
	bullet.global_position = muzzle.global_position
	muzzle.add_child(bullet)
	audio_stream_player_2d.play()


func _update_ammo(ammo_count, _grenades_count) -> void:
	ammo = ammo_count






