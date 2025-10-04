extends Node2D

signal back_to_menu

func _input(_event):
	if Input.is_action_pressed("ui_cancel"): # Triggered by pressing ESC or a mapped key
		GameManager.set_scene("menu")
