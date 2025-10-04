extends Control

var game_state

var current_screen: Node = null

func _ready():
	# Now that we know menu_container is valid, we can safely call get_node on it.
	set_game_state("menu")
	SignalBus.start_game.connect(Callable(func() -> void:
		print("GameManager: Signal received! Starting game.")
		# This function will run when ANY node calls SignalBus.start_game.emit()
		set_game_state("game") 
	))
	
func set_game_state(state: String) -> void:
	if current_screen:
		current_screen.queue_free()
		current_screen = null
	
	var scene_path := ""
	match state:
		"menu": scene_path = "res://scenes/MainMenuScreen.tscn"
		"game": scene_path = "res://scenes/Game01.tscn"
		_:
			push_warning("Unknown menu state: %s" % state)
			return
			
	var scene = load(scene_path).instantiate()
	add_child(scene)
	current_screen = scene
	
	if scene.has_signal("back_to_menu"):
		scene.back_to_menu.connect(Callable(func() -> void:
			set_game_state("menu")
		))
