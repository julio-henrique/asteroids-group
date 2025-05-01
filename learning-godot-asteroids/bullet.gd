extends Area2D

@export var speed: float = 800.0 # Allow adjusting speed in Inspector
var direction: Vector2 = Vector2.ZERO # Initial direction is zero

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	# Use modern signal connection syntax
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	# Connect the signal owned by this Area2D instance
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Move based on direction, speed, and delta time
	position += direction * speed * delta

# --- Signal Handlers ---
func _on_screen_exited():
	queue_free() # Remove bullet when it leaves the screen

func _on_body_entered(body: Node2D):
	# For now, just destroy the bullet when it hits any physics body
	queue_free()
	# Later, we'll add checks here: if body.is_in_group("asteroids"): ...
