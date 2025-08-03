extends Control

@onready var resume_button = $ColorRect/VBoxContainer/ResumeButton

func _ready():
	# Hide the menu by default when the game starts.
	hide()
	
func _unhandled_input(event: InputEvent):
	# Listen for the pause action to unpause the game.
	if event.is_action_pressed("Pause"): # and get_tree().paused:
		get_tree().call_group("world_manager", "toggle_pause")

func open_menu():
	# This function will be called from our world script.
	show()
	# Grab focus on the resume button so the controller can navigate.
	resume_button.grab_focus()

func _on_resume_button_pressed():
	# We'll let the world script handle closing the menu and unpausing.
	get_tree().call_group("world_manager", "toggle_pause")

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	# Unpause before changing scenes to avoid issues.
	get_tree().paused = false
	SceneManager.goto_scene("res://main_menu.tscn")
