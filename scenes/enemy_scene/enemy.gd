class_name Enemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: Area2D = $HitBox
const BLOOD_SPLATTER = preload("res://scenes/blood_splatter_scene/blood_splatter.tscn")

var health :int = 2
const SPEED = 100


func _ready() -> void:
	animation_player.play("idle")
	hit_box.area_entered.connect(_on_hit_box_entered)
	


func _process(delta: float) -> void:
	animation_player.play("move_right")
	var direction = Vector2.RIGHT
	velocity = SPEED * direction
	move_and_slide()
	

func _on_hit_box_entered(area :Area2D) -> void :
	set_process(false)
	var blood = BLOOD_SPLATTER.instantiate()
	blood.position.y -= 25
	add_child(blood)
	
	if area is Bullet:
		health -= 1
	if area.name == "ExplosiveArea":
		health = 0
	if health > 0:
		animation_player.play("hurt")
		await animation_player.animation_finished
		set_process(true)
		return
	animation_player.play("die")
