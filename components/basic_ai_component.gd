class_name BasicAIComponent
extends Node2D

@export var actor: CharacterBody2D
@export var speed: float = 50.0

var player: Player
var direction: Vector2

@onready var rig: Node2D = %Rig


func _ready() -> void:
    player = get_tree().get_first_node_in_group("players")


func _physics_process(_delta: float) -> void:
    if not player:
        actor.velocity = Vector2.ZERO
    else:
        rig.look_at(player.global_position)
        direction = actor.global_position.direction_to(player.global_position)
        actor.velocity = direction * speed
        actor.move_and_slide()
