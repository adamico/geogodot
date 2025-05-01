class_name Enemy
extends Node2D

@export var level: TileMapLayer
@export var state_chart: StateChart

var player: Player

@onready var stats_component: StatsComponent = $StatsComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent

func _ready() -> void:
	player = get_tree().get_first_node_in_group("players")
	player.capturing.connect(_on_player_capturing)
	player.stop_capturing.connect(_on_player_stop_capturing)
	hurtbox_component.hurt.connect(func(_hitbox_component: HitboxComponent):
		flash_component.flash()
		shake_component.tween_shake()
	)
	stats_component.no_health.connect(queue_free)
	
func _on_calm_state_processing(_delta: float) -> void:
	pass

func _on_alerted_state_processing(_delta: float) -> void:
	pass

func _on_player_capturing() -> void:
	state_chart.send_event("player_is_capturing")
	
func _on_player_stop_capturing() -> void:
	state_chart.send_event("player_stops_capturing")
