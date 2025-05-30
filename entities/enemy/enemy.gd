class_name Enemy
extends CharacterBody2D

signal died

var capture_faction: int

@onready var rig: Node2D = %Rig
@onready var shaker:= Shaker.new(rig)
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var effects_animation_player: AnimationPlayer = %EffectsAnimationPlayer
@onready var spawner_component: SpawnerComponent = %SpawnerComponent


func _ready() -> void:
    add_to_group("enemies")
    capture_faction = Constants.CaptureFactions.ENEMIES
    hurtbox_component.hurt.connect(_on_hurtbox_component_hurt)
    died.connect(_on_death)


func _on_hurtbox_component_hurt(_hitbox_component: Node) -> void:
    effects_animation_player.play("flash")
    shaker.shake(4.0, 0.2)


func _on_death() -> void:
    spawner_component.spawn(rig.global_position)
    queue_free()
