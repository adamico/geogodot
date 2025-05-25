@tool
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var stats_component: StatsComponent

func _ready() -> void:
    stats_component.health_changed.connect(_on_actor_health_changed)


func _draw() -> void:
    draw_circle(Vector2.ZERO, 8, Color.BLACK, 1.0)


func _process(_delta: float) -> void:
    queue_redraw()


func _on_actor_health_changed(actor: Node2D, current_health: int) -> void:
    if actor is not Player:
        return
    if current_health >= actor.max_health / 3:
        animation_player.stop()
    if current_health >= actor.max_health / 3 * 2:
        animation_player.play("three")
    if current_health == actor.max_health:
        animation_player.play("six")
