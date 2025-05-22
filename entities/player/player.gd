class_name Player
extends CharacterBody2D

signal dead

const SIZE = preload("res://entities/player/size.tscn")
const CURSOR = preload("res://assets/sprites/tile_0055.png")

@export var level: TileMapLayer
@export var capture_action: GUIDEAction
@export var move_action: GUIDEAction
@export var shoot_action: GUIDEAction
@export var target_action: GUIDEAction
@export var number: int
@export var relative_to_player: RelativeToPlayerModifier

var captured_cells: Array[Vector2i]
var input_direction: Vector2

@onready var state_chart: StateChart = $StateChart
@onready var capture_component: CaptureComponent = %CaptureComponent
@onready var free_move_component: FreeMoveComponent = %FreeMoveComponent
@onready var shoot_component: ShootComponent = %ShootComponent
@onready var stats_component: StatsComponent = %StatsComponent
@onready var target_component: TargetComponent = %TargetComponent
@onready var death_component: DeathComponent = %DeathComponent
@onready var power_up_component: PowerUpComponent = %PowerUpComponent
@onready var finished_capturing_sound: AudioStreamPlayer = $Sounds/FinishedCapturing
@onready var rig: Node2D = $Rig
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent


func _ready() -> void:
    add_to_group("players")
    position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
    position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)

    capture_component.level = level
    capture_component.successful_capture.connect(_on_capture_component_successful_capture)
    capture_action.triggered.connect(capture_component.on_try_capture)
    capture_action.completed.connect(capture_component.on_stop_capturing)

    shoot_action.triggered.connect(shoot_component.fire_projectile)
    shoot_action.completed.connect(shoot_component.stop_firing)

    for power: String in ["size", "capture", "laser"]: _setup_initial_power_stats(power)
    power_up_component.size_up.connect(_on_power_up_component_size_up)
    Input.set_custom_mouse_cursor(CURSOR, Input.CursorShape.CURSOR_ARROW, Vector2(8,8))


func _process(_delta: float) -> void:
    input_direction = move_action.value_axis_2d
    free_move_component.direction = input_direction

    relative_to_player.player_coordinates = rig.global_position
    var target_direction = target_action.value_axis_2d
    if target_direction: target_component.direction = target_direction


func _setup_initial_power_stats(power: String) -> void:
    var power_value: int = stats_component.get(power + "_power")
    for i: int in range(power_value + 1):
        stats_component.call("@" + power + "_power_setter", i)


func _reveal_pickup_at(cell) -> void:
    var found_pickup: Pickup = _pickup_at(cell)
    if not found_pickup: return

    var tween = create_tween()
    tween.tween_callback(func() -> void:
            found_pickup.reveal.emit()
    ).set_delay(finished_capturing_sound.stream.get_length())

func _pickup_at(cell) -> Node:
    var pickups: Array[Node] = get_tree().get_nodes_in_group("pickups")
    var found_pickup: Node

    for a_pickup: Pickup in pickups:
        if level.local_to_map(a_pickup.global_position) == cell: found_pickup = a_pickup

    return found_pickup


func _set_captured(cell) -> void:
    level.set_cell(cell, 0, Vector2i(number + 1, 0))
    captured_cells.append(cell)


func _on_capture_component_successful_capture(cells) -> void:
    finished_capturing_sound.play()
    for cell in cells:
        _set_captured(cell)
        _reveal_pickup_at(cell)


func _on_power_up_component_size_up() -> void:
    var size_scene = SIZE.instantiate()
    var starting_positions: Array[Vector2] = [
        Vector2.ZERO,
        Vector2.RIGHT,
        Vector2.LEFT,
        Vector2.UP,
        Vector2.DOWN
    ]
    var size_power = stats_component.size_power
    size_scene.position = starting_positions[size_power] * Constants.TILE_SIZE
    rig.add_child(size_scene)
