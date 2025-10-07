extends CharacterBody2D

const SWORD_SLICE_STREAM = preload("res://assets/music/sword.mp3") 
const ATTACK_RANGE = 50.0 # How far to the side the rectangle extends
const ATTACK_WIDTH = 50.0  # How "thick" the attack rectangle is (e.g., 10 units wide)
const MONSTER_MASK = 1     # Change this to the specific layer your monsters reside on

@onready var animated_sprite = $AnimatedSprite2D
@onready var walking_sound = $Walking
@onready var attack_timer = $AttackTimer
@onready var slash_animation = $Slash
const SPEED = 150.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	
	var animation_name = "idle"
	var is_moving = direction != Vector2.ZERO

	if is_moving:
		if not walking_sound.playing:
			walking_sound.play()
		if direction.y > 0:
			animation_name = "walk_down"
		elif direction.y < 0:
			animation_name = "walk_up"
		elif direction.x != 0:
			animation_name = "walk_sides"
			animated_sprite.flip_h = direction.x < 0
	else:
		walking_sound.stop()
	
	if animated_sprite.get_animation() != animation_name:
		animated_sprite.play(animation_name)
		
	move_and_slide()
	
func attack():
	if attack_timer.is_stopped():
		if Input.is_action_pressed("attack"):
			var mouse_position = get_global_mouse_position()
			var should_flip_h = mouse_position.x < global_position.x
			if should_flip_h:
				slash_animation.flip_h = true
				slash_animation.flip_v = true
				slash_animation.position.x = -13
			else:
				slash_animation.flip_h = false
				slash_animation.flip_v = false
				slash_animation.position.x = 13

			# --- Execute Attack ---
			attack_timer.start()
			attack_hit_calculation(should_flip_h)
			slash_animation.play("slash")
			var temp_audio_player = AudioStreamPlayer2D.new()
			add_child(temp_audio_player)
			temp_audio_player.stream = SWORD_SLICE_STREAM
			temp_audio_player.finished.connect(temp_audio_player.queue_free)
			temp_audio_player.global_position = global_position
			temp_audio_player.play()
			
func attack_hit_calculation(should_flip_h):
	var space_state = get_world_2d().direct_space_state
		# Define a rectangular query shape
	var query = PhysicsShapeQueryParameters2D.new()
	var rect_shape = RectangleShape2D.new()
		
		# Set the dimensions of the attack box (e.g., 20 wide, 10 tall)
	rect_shape.extents = Vector2(ATTACK_RANGE / 2.0, ATTACK_WIDTH / 2.0) 
	query.set_shape(rect_shape)

	var attack_center_x: float
		
	if should_flip_h:
			# If facing left, move the center 10 units to the left
		attack_center_x = global_position.x - ATTACK_RANGE/2
	else:
			# If facing right, move the center 10 units to the right
		attack_center_x = global_position.x + ATTACK_RANGE/2
		# Position the center of the rectangle
	var attack_center_position = Vector2(attack_center_x, global_position.y)
	query.transform = Transform2D(0, attack_center_position) # Center the rect
		
	query.collision_mask = MONSTER_MASK
	query.collide_with_areas = true
		
	var hit_results = space_state.intersect_shape(query)
	
	for result in hit_results:
		var collider = result.collider
		if collider.is_in_group("monsters"): 
			collider.take_damage(25) # Call monster damage function

# You would call attack() inside _process or _physics_process
func _process(_delta):
	attack()

func _on_attack_timer_timeout() -> void:
	attack_timer.stop()
	pass # Replace with function body.
