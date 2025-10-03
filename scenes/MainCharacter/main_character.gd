extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction * SPEED

	if direction.x != 0 or direction.y != 0:
		animated_sprite.play("walk")
		animated_sprite.flip_h = direction.x < 0
	else:
		animated_sprite.play("idle")
	move_and_slide()
