extends Control

signal back_to_main_menu

func _on_back_button_pressed() -> void:
	emit_signal("back_to_main_menu")
