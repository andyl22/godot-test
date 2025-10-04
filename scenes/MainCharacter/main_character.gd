extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = direction * SPEED

    if direction.y > 0:
        animated_sprite.play("walk_down")

    if direction.y < 0:
        animated_sprite.play("walk_up")

    if direction.x != 0 and direction.y == 0:
        animated_sprite.play("walk_sides")
        animated_sprite.flip_h = direction.x < 0

    if direction == Vector2.ZERO:
        animated_sprite.play("idle")

    move_and_slide() 
