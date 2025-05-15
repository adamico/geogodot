class_name Enemy
extends Node2D

signal dead

@export var level: TileMapLayer
@export var state_chart: StateChart
@export var base_ai_component: BaseAIComponent
@export var move_component: Node

var player: Player
var home_position: Vector2

@onready var stats_component: StatsComponent = %StatsComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var flash_component: FlashComponent = %FlashComponent
@onready var shake_component: ShakeComponent = %ShakeComponent


func _ready() -> void:
    add_to_group("enemies")
    _react_to_player()
    hurtbox_component.level = level
    _setup_base_ai_component()


func _react_to_player() -> void:
    player = get_tree().get_first_node_in_group("players")
    if not player: return
    player.capture_component.capture.connect(_on_player_capturing)
    player.capture_component.stop_capture.connect(_on_player_stop_capturing)
    player.dead.connect(_on_player_dead)


func _setup_base_ai_component() -> void:
    if not base_ai_component: return
    base_ai_component.level = level
    base_ai_component.player = player


func _on_player_capturing() -> void:
    state_chart.send_event("player_is_capturing")


func _on_player_stop_capturing() -> void:
    state_chart.send_event("player_stops_capturing")


func _on_player_dead() -> void:
    state_chart.send_event("player_dead")


func _on_hurtbox_component_hurt(_hitbox_component: HitboxComponent) -> void:
    flash_component.flash()
    shake_component.tween_shake()
    state_chart.send_event("hurt_by_player")


func _on_stats_component_no_health() -> void:
    queue_free()


func _on_moving_state_processing(_delta: float) -> void:
    if base_ai_component.path.is_empty():
        state_chart.send_event("no_path")
        return
    var target_position = base_ai_component.path[0]
    var from = level.local_to_map(global_position)
    var direction: Vector2 = target_position - from
    move_component.move(direction)
