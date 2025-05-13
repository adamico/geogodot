class_name ShootComponent
extends Node2D

const GUN = preload("res://assets/sprites/gun.png")

@export var actor: Node2D
@export var state_chart: StateChart
@export var laser_scene: PackedScene
@export var target_component: TargetComponent
@export var shoot_sound: AudioStreamPlayer
@export var stats_component: StatsComponent

@onready var target_animation_player: AnimationPlayer = %AnimationPlayer
@onready var to_can_shoot: Transition = %ToCanShoot


func fire_laser() -> void:
    state_chart.send_event("shoot")

func _shoot() -> void:
    assert(laser_scene is PackedScene,
            "Error: the scene export was never set on this spawner component")
    _spawn_laser(target_component.global_position)
    var size_components = get_tree().get_nodes_in_group("size")
    for size_component in size_components:
        _spawn_laser(size_component.global_position)


func _spawn_laser(spawn_position) -> void:
    var laser: Node2D = laser_scene.instantiate()
    laser.position = spawn_position
    laser.direction = target_component.direction
    laser.rotate(target_component.direction.angle())
    actor.add_sibling(laser)


func _on_cooldown_state_exited() -> void:
    var tween = create_tween()
    tween.tween_property(target_component, "self_modulate", Color(1,1,1,0), 0.2)


func _on_cooldown_state_entered() -> void:
    var shoot_cooldown = 1.0 / (stats_component.laser_power + 1)
    to_can_shoot.delay_seconds = shoot_cooldown
    target_component.texture = GUN
    create_tween().tween_property(target_component, "self_modulate", Color(1,1,1,1), 0.2)

    shoot_sound.play()
    _shoot()
