## Gets a random spawn position just left of the viewport and spawns enemies at random intervals.
extends Node2D
signal death_counter(count)

const MIN_TIME :float = .5
const MAX_TIME :float = 1.5


## The enemy scene.
const ENEMY_SCENE :PackedScene = preload("res://scenes/enemy_scene/enemy.tscn")
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


var death_count := 0


# Connect the timer timeout signal and randomize the timer.
func _ready() -> void :
	timer.timeout.connect(_on_timer_timeout)
	reset_timer()


## Spawn an enemy and reset the timer.
func _on_timer_timeout() -> void :
	spawn_enemy()
	reset_timer()


## Instance a enemy scene, position it to the spawn marker, and add enemy to scene.
func spawn_enemy() -> void :
	var enemy = ENEMY_SCENE.instantiate()
	enemy.died.connect(_on_enemy_died)
	enemy.position = get_spawn_position()
	enemy.top_level = true
	add_child(enemy)


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
	timer.wait_time = randf_range(MIN_TIME, MAX_TIME)
	timer.start()




