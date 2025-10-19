extends Control

signal back_to_main_menu

@onready var api_key = $VBoxContainer/EnterApiKey

func _ready() -> void:
	api_key.text = ApiConfig.api_key

func _on_back_button_pressed() -> void:
	get_parent().set_menu_state("main")

func _on_enter_api_key_text_submitted(value: String) -> void:
	ApiConfig.save_api_key(value)
