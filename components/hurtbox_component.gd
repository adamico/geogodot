class_name HurtboxComponent
extends Area2D

signal hurt(hitbox)

@export var flash_component: FlashComponent

var is_invincible = false:
    set(value):
        is_invincible = value

        for child in get_children():
            if not child is CollisionShape2D and not child is CollisionPolygon2D: continue
            # Use call deferred to make sure this doesn't happen in the middle of the
            # physics process
            child.set_deferred("disabled", is_invincible)


func _ready() -> void:
    hurt.connect(_on_hurt_by)


func _on_hurt_by(_hitbox: HitboxComponent) -> void:
    flash_component.flash()
