extends Control

signal go_to_settings

func _on_settings_button_pressed() -> void:
	emit_signal("go_to_settings")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
func _input(_event):
	if Input.is_action_pressed("ui_cancel"): # Triggered by pressing ESC or a mapped key
		get_tree().quit()

func _on_start_game_button_pressed() -> void:
	SignalBus.start_game.emit() 
