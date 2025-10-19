extends CanvasLayer

@onready var player_input: LineEdit = $Box/TextureRect/MarginContainer/VBoxContainer/Input
@onready var dialogue_label: RichTextLabel = $Box/TextureRect/MarginContainer/VBoxContainer/ChatText
var typewriter_tween: Tween = null 
var dialogue_lines: Array = ["..."]:
	set(value):
		dialogue_lines = value
	get:
		return dialogue_lines
var char_context: Dictionary

func _ready():
	get_tree().paused = true
	set_dialogue_lines(["... what is it?"])
	_wait_for_player_input()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("skip_text"):
		get_viewport().set_input_as_handled()
		if typewriter_tween != null and typewriter_tween.is_running(): _skip_typing()
		elif dialogue_lines.size(): _display_next_line()
			
func _display_next_line():
	while(dialogue_lines.size()):
		dialogue_label.text = dialogue_lines.pop_front()
		dialogue_label.visible_characters = 0
		
		typewriter_tween = create_tween()
		typewriter_tween.tween_property(
			dialogue_label, 
			"visible_characters", 
			dialogue_label.text.length(),
			dialogue_label.text.length()*.02 # Total time to reach the target
		).set_ease(Tween.EASE_OUT)
		# immediately activates the input again
		if dialogue_lines.size():
			typewriter_tween.tween_interval(3)
			
		await typewriter_tween.finished
		
		if !dialogue_lines.size(): _wait_for_player_input()

func _skip_typing():
	if typewriter_tween != null and typewriter_tween.is_running():
		typewriter_tween.kill()
		typewriter_tween = null
		dialogue_label.visible_characters = -1
		if !dialogue_lines.size():
			_wait_for_player_input()

func _wait_for_player_input():
	player_input.text = ""
	player_input.editable = true

func _end_dialogue():
	queue_free()
	get_tree().paused = false
	
func set_dialogue_lines(lines):
	dialogue_lines = lines
	_display_next_line()

func _on_input_text_submitted(prompt_text: String) -> void:
	handle_chat_input(prompt_text)
	player_input.editable = false
	
func _on_request_completed(result, response_code, headers, body):
	var json_response = JSON.parse_string(body.get_string_from_utf8())
	print(json_response)
	if response_code == 200:
		set_dialogue_lines(json_response.choices[0].message.content.split("\n\n", false))
	Net.api_request_completed.disconnect(_on_request_completed)
	
func handle_chat_input(prompt_text: String):
	Net.api_request_completed.connect(_on_request_completed)
	Net.send_post_request(prompt_text, char_context)
	
func _input(_event):
	if Input.is_action_pressed("ui_cancel"): # Triggered by pressing ESC or a mapped key
		get_viewport().set_input_as_handled()
		_end_dialogue()
