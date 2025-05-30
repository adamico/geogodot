class_name HurtComponent
extends Node

@export var stats_component: StatsComponent
@export var hurtbox_component: HurtboxComponent
@export var actor: Node2D

func _ready() -> void:
    hurtbox_component.hurt.connect(_on_hurtbox_component_hurt)


func _on_hurtbox_component_hurt(hitbox: Area2D) -> void:
    stats_component.health -= hitbox.damage
    EventBus.actor_damaged.emit(actor, hitbox.damage, stats_component.health)
