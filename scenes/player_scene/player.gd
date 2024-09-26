## The player character.  Stands tall on his fortress with guns and grenades held high.
extends Node2D

signal ammunition_counter(ammo:int, grenades:int)
signal enemies_killed(count)

const VOICE_LINES = [
	preload("res://scenes/player_scene/sounds/01._thats_gotta_hurt.wav"),
	preload("res://scenes/player_scene/sounds/02._somebody_call_a_doctor.wav"),
	preload("res://scenes/player_scene/sounds/03._how_embarrassing_.wav"),
	preload("res://scenes/player_scene/sounds/04._cleanup_on_aisle_4.wav"),
	preload("res://scenes/player_scene/sounds/05._that_definitely_shouldnt_bend_that_way.wav"),
	preload("res://scenes/player_scene/sounds/06._thats_gonna_leave_a_mark.wav"),
	preload("res://scenes/player_scene/sounds/07._insurance_for_that_face.wav"),
	preload("res://scenes/player_scene/sounds/08._what_a_beating.wav"),
	preload("res://scenes/player_scene/sounds/09._are_you_not_entertained.wav"),
	preload("res://scenes/player_scene/sounds/10._one-way_ticket_to_the_nursing_home.wav"),
	preload("res://scenes/player_scene/sounds/11._i_felt_that_one.wav"),
	preload("res://scenes/player_scene/sounds/13._viewer_discretion_is_advised.wav"),
	preload("res://scenes/player_scene/sounds/14._thats_unfortunate.wav"),
	preload("res://scenes/player_scene/sounds/15._what_a_snoozefest.wav"),
	preload("res://scenes/player_scene/sounds/17._the_feeding_tube.wav"),
	preload("res://scenes/player_scene/sounds/18._why_i_love_my_job.wav"),
	preload("res://scenes/player_scene/sounds/19._that_looks_painful.wav"),
	preload("res://scenes/player_scene/sounds/20._instant_vegetable.wav"),
	preload("res://scenes/player_scene/sounds/21._i_heard_a_crack.wav"),
	preload("res://scenes/player_scene/sounds/23._a_raise_for_the_cleanup_crew.wav"),
	preload("res://scenes/player_scene/sounds/25._resistant_tissue.wav"),
	preload("res://scenes/player_scene/sounds/26._weak_sauce.wav"),
]
var line_index := 0


const GRENADE = preload("res://scenes/grenade_scene/grenade.tscn")
# The max ammo and grenades the player can hold. (Infinite reload of gun ammo.)
const MAX_AMMO = 30
const MAX_GRENADES = 99

## The pivot for where the player holds the gun, the gun rotates on this pivot to aim at enemies.
@onready var marker_gun_pivot: Marker2D = $MarkerGunPivot
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


## Current ammo count.
var ammo := 0
## Current grenade count.
var grenades := 0


func _ready() -> void :
	ammo = MAX_AMMO
	grenades = MAX_GRENADES	
	get_viewport().ready.connect(func() -> void: ammunition_counter.emit(ammo, grenades))
	get_tree().get_first_node_in_group("spawner").death_counter.connect(_on_enemy_killed)


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
		

func launch_grenade(target_destination:Vector2) -> void :
	var grenade = GRENADE.instantiate()
	grenade.position = marker_gun_pivot.global_position
	add_child(grenade)
	grenade.initialize(target_destination)


func _on_enemy_killed(_count:int):
	enemies_killed.emit(_count)
	randomize()
	if randi_range(0, 100) < 80: return
	line_index = wrapi(line_index +1, 0, VOICE_LINES.size())
	if audio_stream_player.playing == false:
		audio_stream_player.stream = VOICE_LINES[line_index]
		audio_stream_player.play()


