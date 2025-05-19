class_name MoveComponent
extends Node

@export var actor: Node2D
@export var direction: Vector2
@export var speed:= 70

func _physics_process(delta: float) -> void:
    if not actor: return
    actor.translate(direction * speed * delta)
