extends Node

@onready var game_over_screen = $CanvasLayer/GameOverScreen

func _ready():
	# Reset stats every time the level loads.
	PlayerStats.reset()
	# Connect to the player_died signal.
	PlayerStats.player_died.connect(_on_player_died)

func _on_player_died():
	# Pause the game and show the game over screen.
	get_tree().paused = true
	game_over_screen.visible = true
