class_name HurtboxComponent
extends Area2D

signal hurt(hitbox)

@export var flash_component: FlashComponent

func _ready() -> void:
    hurt.connect(func(_hitbox_component: HitboxComponent):
        flash_component.flash()
    )

var is_invincible = false :
    set(value):
        is_invincible = value

        for child in get_children():
            if not child is CollisionShape2D and not child is CollisionPolygon2D: continue
            # Use call deferred to make sure this doesn't happen in the middle of the
            # physics process
            child.set_deferred("disabled", is_invincible)
