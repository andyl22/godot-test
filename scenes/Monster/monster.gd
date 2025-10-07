extends CharacterBody2D

@onready var slime_animations = $SlimeAnimations
const SPEED = 20.0
const CHANGE_INTERVAL = 1.0 
var health = 25.00
var change_timer = 0.0
var is_dead

func _ready():
	add_to_group("monsters")
	
func _physics_process(delta: float) -> void:
	change_timer -= delta
	if change_timer <= 0:
		set_random_velocity()
	slime_animations.play("move")
	move_and_slide()
	
func _process(delta: float) -> void:
	if health <=0 && !is_dead:
		is_dead = true
		die()

func set_random_velocity():
	change_timer = 10
	var random_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if random_direction.length_squared() > 0:
		velocity = random_direction.normalized() * SPEED
	else:
		# If the random direction is (0, 0), just set a speed in one direction.
		velocity = Vector2(SPEED, 0).rotated(randf() * TAU)
		
func take_damage(amount):
	health -= amount
	
func die():
	set_physics_process(false)
	velocity = Vector2.ZERO
	slime_animations.play("death")
	slime_animations.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func _on_animation_finished():
	if slime_animations.get_animation() == "death":
		# If it was, the node can now safely delete itself
		queue_free()
