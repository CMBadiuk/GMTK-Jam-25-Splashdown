extends Control

@onready var controls_screen = $ControlsScreen

func _on_start_button_pressed() -> void:
	SceneManager.goto_scene("res://world.tscn")

func _on_controls_button_pressed() -> void:
	controls_screen.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	controls_screen.visible = false
