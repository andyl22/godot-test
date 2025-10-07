extends CanvasLayer

@onready var health_bar = $HudControl/HealthBar

func _ready():
	health_bar.value = GlobalState.health
	SignalBus._health_changed.connect(_on_player__health_changed)
	
func _on_player__health_changed(newHealthValue):
	health_bar.value = newHealthValue
