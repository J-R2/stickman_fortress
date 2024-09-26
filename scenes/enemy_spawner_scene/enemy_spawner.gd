## Gets a random spawn position just left of the viewport and spawns enemies at random intervals.
## Keeps track of how many enemies have died.
extends Node2D

signal death_counter(count) ## To update the player that they killed an enemy.
var death_count := 0 ## The current kill count of the player.

## The enemy scene.
const ENEMY_SCENE :PackedScene = preload("res://scenes/enemy_scene/enemy.tscn")

const START_SPAWN_COUNT := 10  ## Wave 1 max spawned enemies
const START_TIME_MIN := 0.5  ## Wave 1 minimum time between enemy spawns.
const START_TIME_MAX := 1.5  ## Wave 1 maximum time between enemy spawns.

var min_time :float = START_TIME_MIN  ## Current wave minimum time between enemy spawns. Changes every other wave.
var max_time :float = START_TIME_MAX  ## Current wave maximum time between enemy spawns. Changes every other wave.
var cur_wave_max_spawns :int = START_SPAWN_COUNT ## The number of enemies to spawn for the current wave.
## Keeps track of how many enemies were spawned on the current wave.  Does not exceed cur_wave_max_spawns. Resets each wave.
var cur_wave_spawn_count :int = 0 
var current_wave :int = 1 ## The current wave number.
## How many total enemies need to die to advance to the next wave. Add the cur_wave_max_spawns each wave.
var next_wave_count_flag :int = START_SPAWN_COUNT

## The spawn marker, holds the enemy spawn position.
@onready var marker: Marker2D = $Marker
## Spawn timer, randomized wait_time between spawns.
@onready var timer: Timer = $Timer
# The screen size
@onready var screen_size = 	get_viewport_rect().size
## The highest point an enemy can spawn.
@onready var min_y = marker.position.y
## The lowest point an enemy can spawn.
@onready var max_y = screen_size.y - 80


# Connect the timer timeout signal and randomize the timer.
func _ready() -> void :
	timer.timeout.connect(_on_timer_timeout)
	reset_timer()
	show_wave_banner()


## Spawn an enemy and reset the timer.
func _on_timer_timeout() -> void :
	if cur_wave_spawn_count < cur_wave_max_spawns:
		spawn_enemy()
		reset_timer()
	if death_count == next_wave_count_flag:
		next_wave()


## Sets the parameters of the next wave.
## Change the wave number, show the wave number banner, increase the cur_wave_max_spawns, and decrease time between spawns.
func next_wave() -> void :
	current_wave += 1
	show_wave_banner()
	cur_wave_spawn_count = 0 # Reset the number of enemies that have been spawned for the current wave.
	if current_wave < 5: # For the first 5 waves increase the # of enemies by a larger margin.
		cur_wave_max_spawns = cur_wave_max_spawns * 1.5
	else: # For each wave after Wave 5, increase the # of enemies by a smaller margin.
		cur_wave_max_spawns = cur_wave_max_spawns * 1.2
	next_wave_count_flag += cur_wave_max_spawns # Set the flag to advance to the next wave. (current kill count + # of enemies to kill this wave)
	if current_wave > 0 and current_wave % 2 == 0: # Decrease the time between enemy spawns every other round.
		min_time = max(0.3, min_time - 0.1) # Don't go below .3 seconds
		max_time = max(1.0, max_time - 0.15) # Don't go below 1 second


## Sets the wave banner text and flies the banner across the screen.
func show_wave_banner() -> void :
	timer.stop()
	var txt = "Wave  " + str(current_wave)
	var banner = $WaveBanner
	var label = $WaveBanner/Label
	label.text = txt
	banner.position = Vector2(500, -95)
	var tween = create_tween()
	tween.tween_property(banner, "position:y", screen_size.y + 150, 3.0)
	await tween.finished
	timer.start()
	

## Instance a enemy scene, position it to the spawn marker, and add enemy to scene.
func spawn_enemy() -> void :
	var enemy = ENEMY_SCENE.instantiate()
	enemy.died.connect(_on_enemy_died)
	enemy.position = get_spawn_position()
	enemy.top_level = true
	add_child(enemy)
	cur_wave_spawn_count += 1
	

## Set the death count and emit the signal
func _on_enemy_died() -> void :
	death_count += 1
	death_counter.emit(death_count)


## Returns a random Vector2 position just left of the viewport, within min_y and max_y.
func get_spawn_position() :
	var result = Vector2.ZERO
	result.x = marker.position.x
	result.y = randf_range(min_y, max_y)
	return result


## Randomizes a wait_time and starts the timer.
func reset_timer() -> void :
	randomize()
	timer.wait_time = randf_range(min_time, max_time)
	timer.start()




