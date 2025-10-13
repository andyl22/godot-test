extends Node

var health: float = 0.0:
	set(value):
		health = value
	get:
		return health
var is_in_dialog = false:
	set(value):
		is_in_dialog = value
	get:
		return is_in_dialog

func _ready() -> void:
	health = 100.0
	
func set_health(v) -> void:
	health += v
	SignalBus._health_changed.emit(health)
	
func set_in_dialog(v) -> void:
	is_in_dialog = v
