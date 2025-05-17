class_name BasicAIComponent
extends Node2D

@export var actor: CharacterBody2D
@export var speed: float = 50.0

var player: Player
var direction: Vector2

func _ready() -> void:
    player = get_tree().get_first_node_in_group("players")


func _physics_process(_delta: float) -> void:
    if not actor: return
    if not player: return
    direction = actor.global_position.direction_to(player.global_position)
    actor.velocity = direction * speed
    actor.move_and_slide()
