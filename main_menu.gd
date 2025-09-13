extends Control

@onready var controls_screen = $ControlsScreen
@onready var options_screen = $OptionsScreen
@onready var credits_screen = $CreditsScreen
@onready var start_button = $VBoxContainer/StartButton
@onready var menu_vbox = $VBoxContainer

@onready var background = $TextureRect
@onready var game_logo = $LogoSprite
@onready var company_logo = $"AphelionEnt-logo"

var intro_tween: Tween # To hold the active tween

func _ready() -> void:
	# start_button.grab_focus()
	play_intro_animation()
	
func _unhandled_input(event: InputEvent):
	# If the intro tween is running and the player hits accept...
	if event.is_action_pressed("ui_accept") and is_instance_valid(intro_tween):
		# ...kill the tween and call a function to force the final state.
		intro_tween.kill()
		_set_to_end_state()

func _on_start_button_pressed() -> void:
	SceneManager.goto_scene("res://World.tscn")

func _on_controls_button_pressed() -> void:
	controls_screen.visible = true
	controls_screen.get_node("BackButton").grab_focus()
	menu_vbox.visible = false
	
func _on_options_button_pressed() -> void:
	options_screen.visible = true
	options_screen.get_node("Panel3/VBoxContainer/OptionsBackButton").grab_focus()
	menu_vbox.visible = false
	
func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value - 80)
	print(value - 80)
	
func _on_resoption_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		3:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		4:
			DisplayServer.window_set_size(Vector2i(3840, 2160))
	
func _on_credits_button_pressed() -> void:
	credits_screen.visible = true
	credits_screen.get_node("CreditsBackButton").grab_focus()
	menu_vbox.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	controls_screen.visible = false
	start_button.grab_focus()
	menu_vbox.visible = true
	
func _on_optback_button_pressed() -> void:
	options_screen.visible = false
	start_button.grab_focus()
	menu_vbox.visible = true
	
func _on_credback_button_pressed() -> void:
	credits_screen.visible = false
	start_button.grab_focus()
	menu_vbox.visible = true
	
func play_intro_animation():
	background.modulate.a = 0.0
	menu_vbox.modulate.a = 0.0
	game_logo.modulate.a = 0.0
	company_logo.modulate.a = 0.0
	start_button.focus_mode = Control.FOCUS_NONE
	
	intro_tween = create_tween().set_parallel(false) # Makes the tween run in sequence
	intro_tween.tween_property(background, "modulate:a", 1.0, 2.0)
	intro_tween.tween_property(game_logo, "modulate:a", 1.0, 1.0)
	intro_tween.tween_property(menu_vbox, "modulate:a", 1.0, 1.0)
	
	await intro_tween.finished

	if is_instance_valid(intro_tween):
		_set_to_end_state()
		
func _set_to_end_state():
	intro_tween = null
	
	background.modulate.a = 1.0
	menu_vbox.modulate.a = 1.0
	game_logo.modulate.a = 1.0
	
	start_button.focus_mode = Control.FOCUS_ALL
	start_button.grab_focus()
