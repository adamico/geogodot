class_name ShootComponent
extends Node2D

@export var gun_texture = Resource
@export var actor: Node2D
@export var state_chart: StateChart
@export var projectile_scene: PackedScene
@export var target_component: TargetComponent
@export var shoot_sound: AudioStreamPlayer
@export var stats_component: StatsComponent

@onready var target_animation_player: AnimationPlayer = %AnimationPlayer
@onready var to_can_shoot: Transition = %ToCanShoot
@onready var cooldown: AtomicState = %Cooldown


func _ready() -> void:
    cooldown.state_entered.connect(_on_cooldown_state_entered)


func fire_projectile() -> void:
    state_chart.send_event("shoot")


func stop_firing() -> void:
    create_tween().tween_property(target_component, "self_modulate", Color(1,1,1,0), 0.2)


func _shoot() -> void:
    target_component.texture = gun_texture
    target_animation_player.play("shoot_target_flash_red")
    shoot_sound.play()

    _spawn_projectile(target_component.global_position)
    var size_components = get_tree().get_nodes_in_group("size")
    for size_component in size_components:
        _spawn_projectile(size_component.global_position)


func _spawn_projectile(spawn_position) -> void:
    assert(projectile_scene is PackedScene,
        "Error: the scene export was never set on this spawner component")
    var projectile: Node2D = projectile_scene.instantiate()
    projectile.position = spawn_position
    projectile.direction = target_component.direction
    projectile.rotate(target_component.direction.angle())
    actor.add_sibling(projectile)


func _on_cooldown_state_entered() -> void:
    var shoot_cooldown = 1.0 / (stats_component.laser_power + 1)
    to_can_shoot.delay_seconds = shoot_cooldown
    _shoot()
