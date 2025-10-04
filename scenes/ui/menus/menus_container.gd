extends Control

var current_menu: Node = null

func _ready():
	set_menu_state("main")
	
func set_menu_state(state: String) -> void:
	if current_menu:
		current_menu.queue_free()
		current_menu = null
	
	var scene_path = ""
	match state:
		"main": scene_path = "res://scenes/ui/menus/main_menu/MainMenu.tscn"
		"settings": scene_path = "res://scenes/ui/menus/settings_menu/SettingsMenu.tscn"
		_:
			push_warning("Unknown menu state: %s" % state)
			return
			
	var scene = load(scene_path).instantiate()
	add_child(scene)
	current_menu = scene
