class_name Grenade
extends Node2D

var destination := Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void :
	top_level = true
	$ExplosiveArea/CollisionShape2D.disabled = true


## Sets the target destination and launches the grenade
func initialize(target_destination:Vector2):
	destination = target_destination
	var duration = .5
	var jump_height = 100
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position:x", destination.x, duration)
	tween.parallel().tween_property(self, "global_position:y", destination.y, duration)
	tween.finished.connect(explode)

	
## Plays the explosion animation with queue_free()
func explode() -> void:
	$ExplosiveArea/CollisionShape2D.disabled = false
	animation_player.play("explode")


