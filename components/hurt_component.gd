class_name HurtComponent
extends Node

@export var stats_component: StatsComponent
@export var hurtbox_component: HurtboxComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    hurtbox_component.hurt.connect(func(area_2d: Area2D):
            stats_component.health -= area_2d.damage
    )
