extends StaticBody2D

signal game_over


@onready var hit_box: Area2D = $HitBox
@onready var damage_timer: Timer = $DamageTimer
@onready var progress_bar: ProgressBar = $ProgressBar

var enemy_count :int = 0

var health = 100.0

func _ready() -> void:
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	

func _process(delta: float) -> void:
	if health < 1:
		game_over.emit()
	enemy_count = hit_box.get_overlapping_areas().size()
	

func _on_damage_timer_timeout()-> void :
	health -= enemy_count
	progress_bar.value = health
	




