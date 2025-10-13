extends CharacterBody2D

@onready var prompt_use_text = $PromptUse

var is_interactable: bool = false:
	set(value):
		is_interactable = value
		prompt_use_text.visible = value
	get:
		return is_interactable

func _ready():
	prompt_use_text.visible = false
	Net.api_request_completed.connect(_on_request_completed)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_interactable = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_interactable = false

func _input(event):
	if event.is_action_pressed("use") and is_interactable:
		generate_random_text()
		
func _on_request_completed(result, response_code, headers, body):
	var chat_scene = load("res://scenes/ui/chat/chat.tscn")
	var chatbox_instance = chat_scene.instantiate()
	var dialogue = ["..."]
	if response_code == 200:
		dialogue = body.get_string_from_utf8().split("\n\n", false)
	else:
		print("Request failed with code: ", response_code)
	get_tree().get_root().add_child(chatbox_instance)
	chatbox_instance.set_dialogue_lines(dialogue)
	
func generate_random_text():
	Net.start_api_request("https://baconipsum.com/api/?type=meat-and-filler&paras=3&format=text")


func prompt_request_text():
	var prompt = "test"
	Net.send_post_request(prompt)
