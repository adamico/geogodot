class_name Enemy
extends CharacterBody2D


var capture_faction: int


func _ready() -> void:
    add_to_group("enemies")
    capture_faction = Constants.CaptureFactions.ENEMIES


func _on_hurtbox_component_hurt(_hitbox_component: HitboxComponent) -> void:
    pass
