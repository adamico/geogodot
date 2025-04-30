extends Node2D

const BULLET = preload("res://entities/projectile/bullet.tscn")

@export var rate: float
@export var direction: Vector2
@export var bullet_sibling_path: NodePath
@export var sprite_path: NodePath
@onready var character: Node2D = $"../Character"


func spawn_bullet() -> void:
	var bullet = BULLET.instantiate()
	
	var bullet_sibling = get_node(bullet_sibling_path)
	bullet.global_position = get_node(sprite_path).global_position
	bullet.shooter = owner 
	bullet_sibling.add_sibling(bullet)
	$Sound.play()


func _on_cooldown_state_entered() -> void:
	spawn_bullet()
