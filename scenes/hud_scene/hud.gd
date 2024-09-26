## Ammo and Grenade counter hud.  Displays the current amount of those items in the player's posession.
extends Control

@onready var ammo_label: Label = $AmmoBox/AmmoLabel
@onready var grenade_label: Label = $GrenadeBox/GrenadeLabel
@onready var kill_count_label: Label = $KillCountBox/KillCountLabel

var counter := 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().get_first_node_in_group("player").ammunition_counter.connect(_update_ammo_counters)
	get_tree().get_first_node_in_group("player").enemies_killed.connect(_update_kill_count)


func _process(delta: float) -> void:
	if ammo_label.text == "0":
		ammo_label.text = "R"
		

func _update_kill_count(count) -> void :
	counter += 1
	kill_count_label.text = str(counter)

func _update_ammo_counters(ammo:int, grenades:int) -> void:
	ammo_label.text = str(ammo)
	grenade_label.text = str(grenades)
