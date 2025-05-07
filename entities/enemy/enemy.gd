class_name Enemy
extends Node2D

@export var level: TileMapLayer
@export var state_chart: StateChart
@export var base_ai_component: BaseAIComponent
@export var grid_move_component: GridMoveComponent

var player: Player

@onready var stats_component: StatsComponent = $StatsComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent

func _ready() -> void:
    player = get_tree().get_first_node_in_group("players")
    player.capture_component.capture.connect(_on_player_capturing)
    player.capture_component.stop_capture.connect(_on_player_stop_capturing)
    hurtbox_component.hurt.connect(func(_hitbox_component: HitboxComponent):
        flash_component.flash()
        shake_component.tween_shake()
        state_chart.send_event("hurt_by_player")
    )
    stats_component.no_health.connect(queue_free)
    base_ai_component.level = level
    base_ai_component.player = player
    base_ai_component.home_position = global_position

    player.dead.connect(_on_player_dead)

func _on_player_dead() -> void:
    state_chart.send_event("player_dead")

func _on_player_capturing() -> void:
    state_chart.send_event("player_is_capturing")

func _on_player_stop_capturing() -> void:
    state_chart.send_event("player_stops_capturing")

func _on_moving_state_processing(_delta: float) -> void:
    if base_ai_component.path.is_empty():
        state_chart.send_event("no_path")
        return
    var target_position = base_ai_component.path[0]
    var from = level.local_to_map(global_position)
    var direction: Vector2 = target_position - from
    grid_move_component.move(direction)
