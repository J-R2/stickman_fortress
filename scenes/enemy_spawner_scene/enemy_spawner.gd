extends Node2D

const ENEMY_SCENE :PackedScene = preload("res://scenes/enemy_scene/enemy.tscn")
@onready var marker: Marker2D = $Marker
@onready var timer: Timer = $Timer

@onready var screen_size = 	get_viewport_rect().size
@onready var min_y = marker.position.y
@onready var max_y = screen_size.y - 80

func _ready() -> void :
	timer.timeout.connect(_on_timer_timeout)
	reset_timer()

func _process(delta: float) -> void:
	pass
	
func _on_timer_timeout() -> void :
	reset_timer()
	spawn_enemy()
	
func spawn_enemy() -> void :
	var enemy = ENEMY_SCENE.instantiate()
	enemy.position = get_spawn_position()
	enemy.top_level = true
	add_child(enemy)


func get_spawn_position() :
	var result = Vector2.ZERO
	result.x = marker.position.x
	result.y = randf_range(min_y, max_y)
	return result


func reset_timer() -> void :
	randomize()
	timer.wait_time = randf_range(.5, 1.5)
	timer.start()




