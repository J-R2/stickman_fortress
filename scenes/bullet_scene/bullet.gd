extends Area2D

var speed :int = 5000
const RANGE :int = 2000
var distance :float = 0

func _init() -> void:
	top_level = true

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance += speed * delta
	if distance > RANGE:
		queue_free()
		print("freed")
