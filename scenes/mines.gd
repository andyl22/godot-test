extends Node2D

func _input(_event):
	if Input.is_action_pressed("ui_cancel"): # Triggered by pressing ESC or a mapped key
		GameManager.set_scene("menu")

func _on_leave_mines_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.set_scene("game01")
