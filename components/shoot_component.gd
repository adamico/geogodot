class_name ShootComponent
extends Node2D

const CROSSHAIR_102 = preload("res://assets/sprites/crosshair102.png")
const CROSSHAIR_008 = preload("res://assets/sprites/crosshair008.png")

@export var actor: Node2D
@export var state_chart: StateChart
@export var laser_scene: PackedScene
@export var target_component: TargetComponent
@export var shoot_sound: AudioStreamPlayer
@export var stats_component: StatsComponent

@onready var target_animation_player: AnimationPlayer = %AnimationPlayer
@onready var to_can_shoot: Transition = %ToCanShoot


func _on_cooldown_state_entered() -> void:
    var shoot_cooldown = 1.0 / (stats_component.laser_power + 1)
    to_can_shoot.delay_seconds = shoot_cooldown
    target_animation_player.play("shoot_target_flash_red_once")
    shoot_sound.play()
    _shoot()


func fire_laser() -> void:
    target_component.texture = CROSSHAIR_102
    state_chart.send_event("shoot")


func stop_firing() -> void:
    target_component.texture = CROSSHAIR_008


func _shoot() -> void:
    assert(laser_scene is PackedScene,
            "Error: the scene export was never set on this spawner component")
    _spawn_laser(global_position + target_component.direction)
    var size_components = get_tree().get_nodes_in_group("size")
    for size_component in size_components:
        _spawn_laser(size_component.global_position)


func _spawn_laser(spawn_position) -> void:
    var laser: Node2D = laser_scene.instantiate()
    laser.global_position = spawn_position
    laser.direction = target_component.direction
    laser.rotate(target_component.direction.angle())
    actor.add_sibling(laser)
