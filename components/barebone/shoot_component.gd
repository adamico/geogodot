class_name ShootComponent
extends Node2D

@export var player: Node2D
@export var state_chart: StateChart
@export var laser_scene: PackedScene

var target_direction: Vector2

@onready var target_sprite: Sprite2D = $TargetSprite
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

func _process(_delta: float) -> void:
	position = target_direction * 32

func fire_laser() -> void:
	state_chart.send_event("shoot")

func _on_cooldown_state_entered() -> void:
	if target_direction == Vector2.ZERO: return
	shoot_sound.play()
	spawn_laser()
	
func spawn_laser() -> void:
	assert(laser_scene is PackedScene,
		"Error: the scene export was never set on this spawner component")
	var laser: Node2D = laser_scene.instantiate()
	laser.global_position = global_position + target_direction * -8
	laser.direction = target_direction
	laser.rotate(target_direction.angle())

	player.add_sibling(laser)

func _on_cannot_shoot_state_processing(_delta: float) -> void:
	target_direction = Vector2.ZERO

func _on_cannot_shoot_state_exited() -> void:
	pass
