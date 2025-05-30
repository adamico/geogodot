class_name ExplosionComponent
extends Area2D


const PLAYER_COLLISION_LAYER = 1

@export var damage: float = 2.0
@export var actor: CharacterBody2D

var overlapping_areas: Array[Area2D]

@onready var ignite_animation_player: AnimationPlayer = %IgniteAnimationPlayer
@onready var explosion_warning: Node2D = %"Explosion Warning"
@onready var spawner_component: SpawnerComponent = %SpawnerComponent
@onready var rig: Node2D = %Rig


func _ready() -> void:
    area_entered.connect(_on_explosion_area_entered)
    area_exited.connect(func(area): overlapping_areas.erase(area))
    ignite_animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func _on_explosion_area_entered(area: Area2D) -> void:
    overlapping_areas.append(area)
    if area.collision_layer == PLAYER_COLLISION_LAYER:
        explosion_warning.show()
        ignite_animation_player.play("ignite")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
    overlapping_areas.map(func(overlapping_area): overlapping_area.hurt.emit(self))
    EventBus.actor_died.emit(actor)
