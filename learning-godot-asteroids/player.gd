extends CharacterBody2D

signal shoot(bullet_instance)

var bullet_scene:= preload("res://bullet.tscn")

@export var rotation_speed: float = 4.0
@export var thrust_acceleration: float = 400.0
@export var friction: float = 0.1
@export var max_speed: float = 800.0

@onready var muzzle: Marker2D = $Muzzle
@onready var fire_rate_timer: Timer = $FireRateTimer

func _physics_process(delta: float):
	var rotation_direction = 0.0
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1.0
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1.0
	rotation += rotation_direction * rotation_speed * delta

	if Input.is_action_pressed("thrust"):
		velocity += transform.y * -thrust_acceleration * delta
		# DO NOT apply friction here!
	velocity = lerp(velocity, Vector2.ZERO, friction * delta)

	if max_speed > 0 and velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	move_and_slide()
	
		# === Screen Wrapping Logic ===
	# Purpose: Make the ship appear on the opposite side when it leaves the screen.
	# 1. Get Screen Size:
	#    get_viewport_rect() returns a Rect2 representing the game's view area.
	#    .size gives us a Vector2(width, height) of that rectangle.
	var screen_size: Vector2 = get_viewport_rect().size

	# 2. Check and Wrap X-Position:
	#    Check if the center of the player is beyond the screen edges.
	if position.x > screen_size.x:
		# If player went past the right edge, wrap to the left edge.
		position.x = 0
	elif position.x < 0:
		# If player went past the left edge, wrap to the right edge.
		position.x = screen_size.x

	# 3. Check and Wrap Y-Position:
	if position.y > screen_size.y:
		# If player went past the bottom edge, wrap to the top edge.
		position.y = 0
	elif position.y < 0:
		# If player went past the top edge, wrap to the bottom edge.
		position.y = screen_size.y
	
	# === Shooting Check (Moved from _input) ===
	# Check if the shoot action is currently held down
	if Input.is_action_pressed("shoot"):
		# ALSO check if the fire rate timer has finished (is stopped)
		if fire_rate_timer.is_stopped():
			# If both conditions are true, fire a bullet
			fire_bullet()
			# And immediately start the timer to enforce the cooldown
			fire_rate_timer.start()

func fire_bullet():
	var bullet = bullet_scene.instantiate()
	if not muzzle:
		printerr('Muzzle node not found! Cannot fire bullet.')
		return
	
	bullet.global_position = muzzle.global_position
	bullet.rotation = self.rotation
	bullet.direction = -transform.y.normalized()
	emit_signal('shoot', bullet)
	
