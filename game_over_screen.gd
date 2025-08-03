extends Control

@onready var restart_button = $VBoxContainer/RestartButton

func open_menu():
	# This function will be called from the world when the player dies.
	show()
	restart_button.grab_focus()

func _on_restart_button_pressed():
	# Unpause the game and reload the current scene.
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	# Unpause and go back to the main menu.
	get_tree().paused = false
	SceneManager.goto_scene("res://main_menu.tscn")
