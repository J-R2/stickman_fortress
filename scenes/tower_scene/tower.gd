extends StaticBody2D

@onready var hit_box: Area2D = $HitBox


var health = 100.0

func _ready() -> void:
	hit_box.area_entered.connect(_on_hit_box_entered)
	




func _on_hit_box_entered(area:Area2D):
	print(area)
