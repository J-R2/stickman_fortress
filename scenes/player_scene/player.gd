extends Node2D

const GRENADE = preload("res://scenes/grenade_scene/grenade.tscn")

@onready var marker_gun_pivot: Marker2D = $MarkerGunPivot
var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	marker_gun_pivot.look_at(get_global_mouse_position())
	marker_gun_pivot.rotation = clampf(marker_gun_pivot.rotation, -PI/2, PI/2)


func _unhandled_input(event: InputEvent) -> void:
	var is_right_click = (
		event is InputEventMouseButton and
		event.is_pressed() and
		(event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT
	)
	if is_right_click:
		var grenade = GRENADE.instantiate()
		grenade.position = marker_gun_pivot.global_position
		add_child(grenade)
		grenade.initialize((event as InputEventMouseButton).global_position)
		
