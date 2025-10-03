extends Control

signal back_to_main_menu

func _on_back_button_pressed() -> void:
	print("test1")
	emit_signal("back_to_main_menu")
