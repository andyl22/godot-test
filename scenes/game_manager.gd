extends Node

var current_screen: Node = null

func _ready():
	set_scene("menu")
	
func set_scene(state: String) -> void:
	if current_screen:
		current_screen.queue_free()
		current_screen = null
	call_deferred("deferred_set_scene", state)

# New function to handle the scene loading/switching
func deferred_set_scene(state: String) -> void:
	var scene_path := ""
	match state:
		"menu": scene_path = "res://scenes/MainMenuScreen.tscn"
		"game01": scene_path = "res://scenes/Game01.tscn"
		"home": scene_path = "res://scenes/Home.tscn"
		"mines": scene_path = "res://scenes/Mines.tscn"
		"town": scene_path = "res://scenes/Town.tscn"
		_:
			push_warning("Unknown menu state: %s" % state)
			return
			
	var scene = load(scene_path).instantiate()
	add_child(scene)
	current_screen = scene
