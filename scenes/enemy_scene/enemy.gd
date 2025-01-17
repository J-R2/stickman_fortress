class_name Enemy
extends CharacterBody2D

signal died ## Emitted when the enemy dies
var is_dead = false ## To ensure died is only emitted once.

# The nubmer of bullet hits the enemy can take.  Grenades kill on impact.
const MAX_HEALTH :int = 2

## Enemies grunt after being hit.
const HURT_SFX = [
	preload("res://scenes/enemy_scene/sounds/3yell2.wav"),
	preload("res://scenes/enemy_scene/sounds/3yell4.wav"),
	preload("res://scenes/enemy_scene/sounds/3yell7.wav"),
	preload("res://scenes/enemy_scene/sounds/3yell8.wav"),
	preload("res://scenes/enemy_scene/sounds/3yell10.wav"),
	preload("res://scenes/enemy_scene/sounds/3yell12.wav"),
	preload("res://scenes/enemy_scene/sounds/3yell15.wav"),
]
## Plays the hurt_sfx sounds.
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
## Plays the different animations the enemy can do ["die", "hurt", "idle", "run"].
@onready var animation_player: AnimationPlayer = $AnimationPlayer
## Detects bullets or grenades.
@onready var hit_box: Area2D = $HitBox
## A blood_splatter.tscn, instanced when the hit_box is hit.
const BLOOD_SPLATTER = preload("res://scenes/blood_splatter_scene/blood_splatter.tscn")
## The enemy's health, will go to 0 on grenade hits and health-1 on bullet hit.
var health :int = MAX_HEALTH
## The enemy's speed.
const SPEED = 100


func _ready() -> void:
	animation_player.play("idle") # Enemies spawn with idle animation.
	hit_box.area_entered.connect(_on_hit_box_entered)
	


func _process(delta: float) -> void:
	#TODO Figure out how to make it so the enemy attack the base when it collides, repeated in 1 second intervals
	# Find and make enemy "attack" animation
	animation_player.play("move_right")
	var direction = Vector2.RIGHT # enemies always move right
	velocity = SPEED * direction
	move_and_slide()
	

## Handles enemy getting hit by bullets or grenades and creates blood splatter.
func _on_hit_box_entered(area :Area2D) -> void :
	set_process(false)  # Pause the enemy moving while taking damage.
	var blood = BLOOD_SPLATTER.instantiate()
	blood.position.y -= 25 # Spawns on enemy groin if not.
	add_child(blood) # Add it to the scene.
	if !audio_stream_player.playing:
		audio_stream_player.stream = HURT_SFX.pick_random()
		audio_stream_player.play(.23)
	# bullets cause 1 damage
	if area is Bullet:
		health -= 1
	# grenades cause death
	if area.name == "ExplosiveArea": # I need to figure out how to ask if (area is Grenade)? p.s Grenades are Node2Ds
		health = 0
	# if not dead yet
	if health > 0:
		animation_player.play("hurt")
		await animation_player.animation_finished
		set_process(true)
		return # don't play the die animation
	if is_dead == false:
		animation_player.play("die") # die animation, queue_free() is called from animation player at the end of playing
		died.emit()
		is_dead = true
	
