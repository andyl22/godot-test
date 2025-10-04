extends Control

signal back_to_main_menu

func _on_back_button_pressed() -> void:
	get_parent().set_menu_state("main")
