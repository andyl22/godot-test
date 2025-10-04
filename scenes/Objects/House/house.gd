extends RigidBody2D

@onready var prompt_use_text = $PromptUse

var is_door_interactable: bool = false:
	set(value):
		is_door_interactable = value
		prompt_use_text.visible = value
	get:
		return is_door_interactable

func _ready():
	prompt_use_text.visible = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_door_interactable = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_door_interactable = false

func _input(event):
	if event.is_action_pressed("use") and is_door_interactable:
		GameManager.set_scene("game02")
		is_door_interactable = false
		GlobalState.set_health(-10.0)
