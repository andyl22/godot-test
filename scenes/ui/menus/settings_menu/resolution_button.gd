extends Control

@onready var resolution_dropdown = $ResolutionOptionButton
@onready var fullscreen_checkbox = $FullscreenCheckBox

# Make resolutions a member variable
var common_resolutions: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

func _ready():
	# Populate the dropdown
	resolution_dropdown.clear()
	for res in common_resolutions:
		resolution_dropdown.add_item("%sx%s" % [res.x, res.y])

func _on_resolution_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(common_resolutions[index])

func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if(toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
