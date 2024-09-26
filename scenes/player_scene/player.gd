extends Node2D


@onready var marker_gun_pivot: Marker2D = $MarkerGunPivot
var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	marker_gun_pivot.look_at(get_global_mouse_position())
	marker_gun_pivot.rotation = clampf(marker_gun_pivot.rotation, -PI/2, PI/2)

