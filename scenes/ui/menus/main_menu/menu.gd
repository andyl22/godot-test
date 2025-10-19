extends Control

func _on_settings_button_pressed() -> void:
	get_parent().set_menu_state("settings")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_start_game_button_pressed() -> void:
	GameManager.set_scene("game01")
