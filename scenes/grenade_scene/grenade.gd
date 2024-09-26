## An explosive device.
class_name Grenade
extends Node2D

## The destination coordinates of the grenade.  It will travel to destination, then explode.
var destination := Vector2.ZERO
## Plays the "explode" animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void :
	top_level = true # Let the grenade travel freely.
	$ExplosiveArea/CollisionShape2D.disabled = true # Grenades only kill on impact, not during travel.


## Sets the target destination and launches the grenade.
func initialize(target_destination:Vector2):
	destination = target_destination
	var duration = .5
	#var jump_height = 100
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	# I tried making it to do a little "throw" that is why x and y are separate.  It looked weird.  #NOTICE to self, (learn math more)
	tween.tween_property(self, "global_position:x", destination.x, duration)
	tween.parallel().tween_property(self, "global_position:y", destination.y, duration)
	tween.finished.connect(explode) # detonate on arrival at destination

	
## Activates killzone, plays the explosion animation
func explode() -> void:
	$ExplosiveArea/CollisionShape2D.disabled = false # activate the killzone
	animation_player.play("explode") # contains the queue_free function


