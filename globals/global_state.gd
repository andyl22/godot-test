extends Node

var health: float = 0.0:
	set(value):
		health = value
	get:
		return health

func _ready() -> void:
	health = 100.0
	
func set_health(v) -> void:
	health += v
	SignalBus._health_changed.emit(health)
