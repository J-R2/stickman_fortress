## Ammo and Grenade counter hud.  Displays the current amount of those items in the player's posession.
extends Control

@onready var ammo_label: Label = $AmmoBox/AmmoLabel
@onready var grenade_label: Label = $GrenadeBox/GrenadeLabel

func _ready() -> void:
	get_tree().get_first_node_in_group("player").ammunition_counter.connect(_update_ammo_counters)



func _update_ammo_counters(ammo:int, grenades:int) -> void:
	ammo_label.text = str(ammo)
	grenade_label.text = str(grenades)
