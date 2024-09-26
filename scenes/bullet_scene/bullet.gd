class_name Bullet
extends Area2D

var speed :int = 2000
const RANGE :int = 2000
var distance :float = 0

func _init() -> void:
	top_level = true
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance += speed * delta
	if distance > RANGE:
		queue_free()


func _on_area_entered(area:Area2D) -> void:
	queue_free()
