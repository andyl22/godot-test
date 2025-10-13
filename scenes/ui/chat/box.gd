extends CanvasLayer

@onready var dialogue_label: RichTextLabel = $Box/TextureRect/MarginContainer/RichTextLabel
var typewriter_tween: Tween = null 

var dialogue_lines: Array = ["..."]:
	set(value):
		dialogue_lines = value
	get:
		return dialogue_lines

func _ready():
	_display_next_line()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()

		if typewriter_tween != null and typewriter_tween.is_running(): _skip_typing()
		elif !dialogue_lines.size(): _end_dialogue()
		else: _display_next_line()
			
func _display_next_line():
	while(dialogue_lines.size()):
		get_tree().paused = true
		dialogue_label.text = dialogue_lines.pop_front()
		dialogue_label.visible_characters = 0
		
		typewriter_tween = create_tween()
		typewriter_tween.tween_property(
			dialogue_label, 
			"visible_characters", 
			dialogue_label.text.length(),
			dialogue_label.text.length()*.02 # Total time to reach the target
		).set_ease(Tween.EASE_OUT)
		typewriter_tween.tween_interval(3)
		
		await typewriter_tween.finished
		if !dialogue_lines.size(): _end_dialogue()

func _skip_typing():
	if typewriter_tween != null and typewriter_tween.is_running():
		typewriter_tween.stop()
		dialogue_label.visible_characters = -1

func _end_dialogue():
	get_tree().paused = false
	queue_free()
	
func set_dialogue_lines(lines):
	dialogue_lines = lines
	_display_next_line()
