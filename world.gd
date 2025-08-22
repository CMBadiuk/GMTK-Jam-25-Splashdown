extends Node

@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var pause_menu = $CanvasLayer/PauseMenu # Add the PauseMenu instance in the editor
@onready var dialogue_box = $DialogueBox

var intro_dialogue: Array[String] = [
	"I'm so glad I was able to get this pool all to myself.",
	"At least, I hope it's all to myself...",
	"If not, at least I have this new water gun!",
	"Nothing's going to ruin this day!"
]

func _ready():
	# Reset stats every time the level loads.
	PlayerStats.reset()
	# Connect to the player_died signal.
	PlayerStats.player_died.connect(_on_player_died)
	add_to_group("world_manager")
	dialogue_box.start_dialogue(intro_dialogue)

func toggle_pause():
	# This function handles both pausing and unpausing.
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		pause_menu.open_menu()
	else:
		pause_menu.hide()

func _on_player_died():
	# Pause the game and show the game over screen.
	get_tree().paused = true
	game_over_screen.open_menu()
