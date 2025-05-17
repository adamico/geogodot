class_name Enemy
extends CharacterBody2D

signal dead

@onready var stats_component: StatsComponent = %StatsComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var flash_component: FlashComponent = %FlashComponent
@onready var shake_component: ShakeComponent = %ShakeComponent


func _ready() -> void:
    add_to_group("enemies")


func _on_hurtbox_component_hurt(_hitbox_component: HitboxComponent) -> void:
    flash_component.flash()
    shake_component.tween_shake()


func _on_stats_component_no_health() -> void:
    queue_free()
