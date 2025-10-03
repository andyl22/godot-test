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

	# Connect signals
	resolution_dropdown.connect("item_selected", Callable(self, "_on_resolution_selected"))
	fullscreen_checkbox.connect("toggled", Callable(self, "_on_fullscreen_toggled"))

func _on_resolution_selected(index):
	var res = common_resolutions[index]
	DisplayServer.window_set_size(res)
	if fullscreen_checkbox.pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_fullscreen_toggled(pressed):
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		# Keep current resolution
		var index = resolution_dropdown.selected
		DisplayServer.window_set_size(common_resolutions[index])
