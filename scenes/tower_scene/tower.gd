## The player's fortress.
extends StaticBody2D

## Emitted when the fortress is destroyed.
signal game_over

## Where enemies can attack the fortress.
@onready var hit_box: Area2D = $HitBox
## Enemies attack in 1 second intervals.
@onready var damage_timer: Timer = $DamageTimer
## The fortress' health bar.
@onready var progress_bar: ProgressBar = $ProgressBar

## Enemies attack every 1 second. Multiplies by the amount of enemies in the fortress' hit_box.
var enemy_count :int = 0

## The fortress' health.
var health = 100.0


func _ready() -> void:
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	

## Update the health, emit game_over if fort is destroyed, and update the amount of enemies attacking the fort.
func _process(delta: float) -> void:
	if health < 1:
		game_over.emit()
	enemy_count = hit_box.get_overlapping_areas().size()
	
## The fort takes 1 damage, per enemy, per second. (can stack within any given second), call it enemy morale for making it to the fort.
func _on_damage_timer_timeout()-> void :
	health -= enemy_count
	progress_bar.value = health
	




