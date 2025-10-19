extends Node2D

func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		GameManager.set_scene("menu")

func _on_enter_mines_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.set_scene("mines")

func _on_enter_town_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.set_scene("town")
