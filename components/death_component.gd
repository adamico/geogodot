class_name DeathComponent
extends Node

@export var actor: Node2D
@export var stats_component: StatsComponent
@export var death_effect_spawner_component: SpawnerComponent


func _ready() -> void:
    stats_component.no_health.connect(die)


func die() -> void:
    death_effect_spawner_component.spawn(actor.global_position)
    if actor.has_signal("dead"): actor.dead.emit()
    actor.call_deferred("queue_free")
