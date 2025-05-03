class_name ShootComponent
extends Node2D

@export var actor: Node2D
@export var state_chart: StateChart
@export var laser_scene: PackedScene
@export var target_component: TargetComponent
@export var shoot_sound: AudioStreamPlayer

const CROSSHAIR_102 = preload("res://assets/sprites/crosshair102.png")
const CROSSHAIR_008 = preload("res://assets/sprites/crosshair008.png")

@onready var target_animation_player: AnimationPlayer = $"../TargetComponent/AnimationPlayer"

func fire_laser() -> void:
    target_component.texture = CROSSHAIR_102
    state_chart.send_event("shoot")

func stop_firing() -> void:
    target_component.texture = CROSSHAIR_008

func spawn_laser() -> void:
    assert(laser_scene is PackedScene,
        "Error: the scene export was never set on this spawner component")
    var laser: Node2D = laser_scene.instantiate()
    laser.global_position = global_position + target_component.direction
    laser.direction = target_component.direction
    laser.rotate(target_component.direction.angle())
    actor.add_sibling(laser)

func _on_cooldown_state_entered() -> void:
    target_animation_player.play("shoot_target_flash_red_once")
    shoot_sound.play()
    spawn_laser()
