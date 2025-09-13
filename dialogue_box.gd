extends CanvasLayer

signal dialogue_finished

@onready var text_label = $DialoguePanel/RichTextLabel
@onready var continue_prompt = $DialoguePanel/ContinuePrompt

var dialogue_lines: Array[String] = []
var current_line_index := 0
var typewrite_tween: Tween # To store active typewriter tween

func _ready() -> void:
	hide()
	
func start_dialogue(lines: Array[String]):
	dialogue_lines = lines
	current_line_index = 0
	show()
	_show_next_line()
	
func _unhandled_input(event: InputEvent) -> void:
	if not is_visible() or not event.is_action_pressed("ui_accept"):
		return
		
	# Check if the text has finished typing
	if is_instance_valid(typewrite_tween):
		typewrite_tween.kill()
		typewrite_tween = null
		text_label.visible_characters = len(text_label.text)
		continue_prompt.show()
	elif text_label.get_total_character_count() == text_label.visible_characters:
		_show_next_line()
			
func _show_next_line():
	if current_line_index >= dialogue_lines.size():
		hide()
		dialogue_finished.emit()
		return
		
	continue_prompt.hide()
	
	var line = dialogue_lines[current_line_index]
	current_line_index += 1
	
	text_label.text = line
	text_label.visible_characters = 0
	
	# Kill any previous tween just in case, then create and store the new one
	if is_instance_valid(typewrite_tween):
		typewrite_tween.kill()
	typewrite_tween = create_tween()
	
	typewrite_tween.tween_property(text_label, "visible_characters", len(line), len(line) * 0.05)
	
	await typewrite_tween.finished
	typewrite_tween = null
	continue_prompt.show()
