class_name Player
extends Node2D

signal dead

const SIZE = preload("res://entities/player/size.tscn")

@export var level: TileMapLayer
@export var capture_action: GUIDEAction
@export var move_action: GUIDEAction
@export var shoot_action: GUIDEAction
@export var target_action: GUIDEAction
@export var number: int

var captured_cells: Array[Vector2i]
var input_direction: Vector2

@onready var state_chart: StateChart = $StateChart
@onready var capture_component: CaptureComponent = $CaptureComponent
@onready var grid_move_component: GridMoveComponent = $GridMoveComponent
@onready var shoot_component: ShootComponent = $ShootComponent
@onready var stats_component: StatsComponent = %StatsComponent
@onready var target_component: TargetComponent = $TargetComponent
@onready var finished_capturing_sound: AudioStreamPlayer = $Sounds/FinishedCapturing
@onready var death_component: DeathComponent = $DeathComponent
@onready var moving: AtomicState = %Moving
@onready var moving_sound: AudioStreamPlayer = $Sounds/Moving
@onready var stop_moving_sound: AudioStreamPlayer = $Sounds/StopMoving
@onready var power_up_component: PowerUpComponent = $PowerUpComponent


func _ready() -> void:
    add_to_group("players")
    position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
    position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)

    move_action.completed.connect(_on_stopped_moving)
    move_action.triggered.connect(_on_started_moving)

    capture_component.level = level
    capture_action.triggered.connect(capture_component.try_capture)
    capture_action.completed.connect(capture_component.stop_capturing)

    shoot_action.triggered.connect(shoot_component.fire_laser)
    shoot_action.completed.connect(shoot_component.stop_firing)

    power_up_component.size_up.connect(_on_size_up)
    for power: String in ["size", "capture", "laser"]:
        _setup_initial_power_stats(power)


func _process(_delta: float) -> void:
    input_direction = move_action.value_axis_2d
    grid_move_component.move(input_direction)

    var target_direction = target_action.value_axis_2d
    if target_direction: target_component.direction = target_direction


func _setup_initial_power_stats(power: String) -> void:
    var power_value: int = stats_component.get(power + "_power")
    for i: int in range(power_value + 1):
        stats_component.call("@" + power + "_power_setter", i)


func _on_started_moving() -> void:
    if not moving_sound.playing: moving_sound.play()


func _on_stopped_moving() -> void:
    moving_sound.stop()
    stop_moving_sound.play()


func _on_size_up() -> void:
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
    add_child(size_scene)


func _on_capture_component_successful_capture(cells) -> void:
    finished_capturing_sound.play()
    for cell in cells:
        _set_captured(cell)
        _reveal_pickup_at(cell)


func _reveal_pickup_at(cell) -> void:
    var found_pickup: Pickup = pickup_at(cell)
    if not found_pickup: return

    var tween = create_tween()
    tween.tween_callback(func() -> void:
            found_pickup.reveal.emit()
    ).set_delay(finished_capturing_sound.stream.get_length())

func pickup_at(cell) -> Node:
    var pickups: Array[Node] = get_tree().get_nodes_in_group("pickups")
    var found_pickup: Node

    for a_pickup: Pickup in pickups:
        if a_pickup.map_position == cell: found_pickup = a_pickup

    return found_pickup


func _set_captured(cell) -> void:
    level.set_cell(cell, 0, Vector2i(number + 1, 0))
    captured_cells.append(cell)
