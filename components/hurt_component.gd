class_name HurtComponent
extends Node

@export var stats_component: StatsComponent
@export var hurtbox_component: HurtboxComponent


func _ready() -> void:
    hurtbox_component.hurt.connect(func(area_2d: Area2D):
        stats_component.health -= area_2d.damage
        EventBus.actor_damaged.emit(hurtbox_component.actor, area_2d.damage, stats_component.health)
    )
