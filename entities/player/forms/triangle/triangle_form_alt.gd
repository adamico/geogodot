extends Node2D

@export var stats_component: StatsComponent

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
    stats_component.health_changed.connect(_on_actor_health_changed)


func _on_actor_health_changed(actor: Node2D, current_health: int) -> void:
    if actor is not Player:
        return
    if current_health >= actor.max_health / 3:
        animation_player.stop()
    if current_health >= actor.max_health / 3 * 2:
        animation_player.play("three")
    if current_health == actor.max_health:
        animation_player.play("six")
