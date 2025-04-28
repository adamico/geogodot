extends Node2D

@onready var bullet_scene = preload("res://scenes/bullet.tscn")

@export var rate: int = 1
@export var direction: Vector2
@export var bullet_parent_path: NodePath
@export var sprite_path: NodePath


func spawn_bullet() -> void:
	var bullet = bullet_scene.instantiate()
	
	var bullet_parent = get_node(bullet_parent_path)
	bullet.global_position = get_node(sprite_path).global_position
	bullet_parent.add_child(bullet)


func _on_cooldown_state_entered() -> void:
	spawn_bullet()
