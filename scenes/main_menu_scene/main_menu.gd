## The game's main menu, contains a play button, rules page, and an option to quit the game.
extends Control

var buttons = null ## Array of all the buttons.
## The container that holds all the main menu buttons.
@onready var button_v_box_container: VBoxContainer = $Background/ButtonVBoxContainer
## The rules page container.
@onready var rules_v_box_container: VBoxContainer = $Background/RulesVBoxContainer
## The game over page.
@onready var game_over_v_box_container :VBoxContainer = $Background/GameOverVBoxContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Don't pause the menu.
	get_tree().paused = true # pause the rest of the game while using the menu
	buttons = [%PlayButton, %RulesButton, %QuitButton, %ReturnButton, %ReplayButton] # easier to call functions
	var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
	for button in buttons: # make the buttons play a sound when you hover over them
		button.mouse_entered.connect(audio_stream_player.play)
	# connect the buttons to their corresponding functions
	%PlayButton.pressed.connect(_play_game)
	%RulesButton.pressed.connect(show_rules)
	%QuitButton.pressed.connect(get_tree().quit)
	%ReturnButton.pressed.connect(show_main_menu)
	%ReplayButton.pressed.connect(get_tree().reload_current_scene)
	# connect to the game over signal
	get_tree().get_first_node_in_group("tower").game_over.connect(_on_game_over)
	show_main_menu() # start the game on the main menu page


func _on_game_over() -> void:
	show_game_over()


func show_game_over() -> void :
	get_tree().paused = true
	_hide_menu_entries()
	show()
	game_over_v_box_container.show()
	%ReplayButton.disabled = false
	


## Disables all the buttons, hide the menu and unpause the game
func _play_game() -> void:
	_disable_buttons()
	hide()
	get_tree().paused = false


## Hides submenus and only shows the main menu, with activate buttons.
func show_main_menu() -> void :
	_hide_menu_entries()
	button_v_box_container.show()
	%PlayButton.disabled = false
	%RulesButton.disabled = false
	%QuitButton.disabled = false


## Hides the main menu to show the rules page.
func show_rules() -> void :
	_hide_menu_entries()
	rules_v_box_container.show()
	%ReturnButton.disabled = false # enable the button on the rule page


## Disables all the buttons in this node.
func _disable_buttons() -> void :
	for button in buttons:
		button.disabled = true


## Disables all the buttons and hides the menu overlays. (Does not hide the menu background.)
func _hide_menu_entries() -> void :
	_disable_buttons()
	game_over_v_box_container.hide()
	button_v_box_container.hide()
	rules_v_box_container.hide()
