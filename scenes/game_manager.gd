extends Control

var game_state = "menu"

var current_screen: Node = null

func _ready():
	set_menu_state("menu")
	
func set_menu_state(state: String) -> void:
	if current_screen:
		current_screen.queue_free()
		current_screen = null
	
	var scene_path := ""
	match state:
		"menu": scene_path = "res://scenes/MainMenuScreen.tscn"
		_:
			push_warning("Unknown menu state: %s" % state)
			return
			
	var scene = load(scene_path).instantiate()
	add_child(scene)
	current_screen = scene
