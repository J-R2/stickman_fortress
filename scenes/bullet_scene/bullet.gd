class_name Bullet
extends Area2D

var speed :int = 2000  ## The speed of the bullet.
const RANGE :int = 2000  ## The max distance of the bullet. Used to queue_free() when too far away.
var distance :float = 0  ## Keeps track of the bullet's travelled distance.  If distance > RANGE: queue_free()

func _ready() -> void:
	top_level = true  ## Set to top level to allow bullet to travel freely.
	area_entered.connect(_on_area_entered)


## Move the bullet until it goes too far.
func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance += speed * delta
	if distance > RANGE:
		queue_free()


func _on_area_entered(area:Area2D) -> void:
	queue_free()
