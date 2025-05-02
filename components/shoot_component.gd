class_name ShootComponent
extends Node2D

@export var actor: Node2D
@export var state_chart: StateChart
@export var laser_scene: PackedScene
@export var target_component: TargetComponent
@export var shoot_sound: AudioStreamPlayer

func fire_laser() -> void:
    state_chart.send_event("shoot")

func _on_cooldown_state_entered() -> void:
    if target_component.target_direction == Vector2.ZERO: return
    shoot_sound.play()
    spawn_laser()

func spawn_laser() -> void:
    assert(laser_scene is PackedScene,
        "Error: the scene export was never set on this spawner component")
    var laser: Node2D = laser_scene.instantiate()
    laser.global_position = global_position + target_component.target_direction
    laser.direction = target_component.target_direction
    laser.rotate(target_component.target_direction.angle())

    actor.add_sibling(laser)

func _on_cannot_shoot_state_processing(_delta: float) -> void:
    target_component.target_direction = Vector2.ZERO
