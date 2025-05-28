class_name HurtboxComponent
extends Area2D

signal hurt(area_2d)

@export var flash_component: FlashComponent
@export var actor: Node2D

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


func _on_hurt_by(_area_2d: Area2D) -> void:
    flash_component.flash()
