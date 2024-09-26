extends AnimatedSprite2D

const ANIMATION_NAMES = ["blood_1", "blood_2", "blood_3", "blood_4", "blood_5"]

func _ready() -> void:
	play(ANIMATION_NAMES.pick_random())
	animation_finished.connect(queue_free)
