extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
const SPEED = 150.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	var animation_name = "idle"
	var is_moving = direction != Vector2.ZERO

	if is_moving:
		if direction.y > 0:
			animation_name = "walk_down"
		elif direction.y < 0:
			animation_name = "walk_up"
		elif direction.x != 0:
			animation_name = "walk_sides"
			animated_sprite.flip_h = direction.x < 0
	
	if animated_sprite.get_animation() != animation_name:
		animated_sprite.play(animation_name)

	move_and_slide()
