extends Node2D

@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var state_chart: StateChart = $"../StateChart"
@onready var sprite: AnimatedSprite2D = $"../Character/AnimatedSprite2D"

@export var rate: int = 1

@export var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_bullet() -> void:
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = sprite.global_position

func _on_cooldown_state_entered() -> void:
	spawn_bullet()
