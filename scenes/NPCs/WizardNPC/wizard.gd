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
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_interactable = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_interactable = false

func _input(event):
	if event.is_action_pressed("use") and is_interactable:
		get_tree().get_root().add_child(load("res://scenes/ui/chat/chat.tscn").instantiate())
