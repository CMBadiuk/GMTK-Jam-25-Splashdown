extends Control

@onready var controls_screen = $ControlsScreen
@onready var credits_screen = $CreditsScreen
@onready var start_button = $VBoxContainer/StartButton

func _ready() -> void:
	start_button.grab_focus()

func _on_start_button_pressed() -> void:
	SceneManager.goto_scene("res://world.tscn")

func _on_controls_button_pressed() -> void:
	controls_screen.visible = true
	controls_screen.get_node("BackButton").grab_focus()
	
func _on_credits_button_pressed() -> void:
	credits_screen.visible = true
	credits_screen.get_node("CreditsBackButton").grab_focus()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	controls_screen.visible = false
	start_button.grab_focus()
	
func _on_credback_button_pressed() -> void:
	credits_screen.visible = false
	start_button.grab_focus()
