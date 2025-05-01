extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	# Connect player's signal to this script's function
	player.shoot.connect(_on_player_shoot)

func _on_player_shoot(bullet_instance):
	# Add the bullet to the main scene tree, making it appear and move
	add_child(bullet_instance)
