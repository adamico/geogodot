class_name DeathComponent
extends Node


@export var death_effect_spawner_component: SpawnerComponent


func _ready() -> void:
    EventBus.actor_died.connect(_on_no_health)


func _on_no_health(actor) -> void:
    death_effect_spawner_component.spawn(actor.global_position)
