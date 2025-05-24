class_name Enemy
extends CharacterBody2D


var capture_faction: int

@onready var flash_component: FlashComponent = %FlashComponent
@onready var shake_component: ShakeComponent = %ShakeComponent


func _ready() -> void:
    add_to_group("enemies")
    capture_faction = Constants.CaptureFactions.ENEMIES


func _on_hurtbox_component_hurt(_hitbox_component: HitboxComponent) -> void:
    flash_component.flash()
    shake_component.tween_shake()
