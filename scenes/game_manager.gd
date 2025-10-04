extends Node

var current_screen: Node = null

func _ready():
	set_scene("menu")
	
func set_scene(state: String) -> void:
	if current_screen:
		current_screen.queue_free()
		current_screen = null
	
	var scene_path := ""
	match state:
		"menu": scene_path = "res://scenes/MainMenuScreen.tscn"
		"game01": scene_path = "res://scenes/Game01.tscn"
		_:
			push_warning("Unknown menu state: %s" % state)
			return
	var scene = load(scene_path).instantiate()
	add_child(scene)
	current_screen = scene
