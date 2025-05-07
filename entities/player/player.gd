class_name Player
extends Node2D

signal dead

@export var level: TileMapLayer
@export var capture_action: GUIDEAction
@export var move_action: GUIDEAction
@export var shoot_action: GUIDEAction
@export var target_action: GUIDEAction
@export var number: int
@export var health_progress_bar: ProgressBar

var captured_cells: PackedVector2Array

@onready var state_chart: StateChart = $StateChart
@onready var capture_component: CaptureComponent = $CaptureComponent
@onready var grid_move_component: GridMoveComponent = $GridMoveComponent
@onready var shoot_component: ShootComponent = $ShootComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var target_component: TargetComponent = $TargetComponent
@onready var finished_capturing_sound: AudioStreamPlayer = $Sounds/FinishedCapturing
@onready var death_component: DeathComponent = $DeathComponent

func _ready() -> void:
    position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
    position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)

    capture_component.level = level
    capture_action.triggered.connect(capture_component.try_capture)
    capture_action.completed.connect(capture_component.stop_capturing)

    shoot_action.triggered.connect(shoot_component.fire_laser)
    shoot_action.completed.connect(shoot_component.stop_firing)

func _process(_delta: float) -> void:
    var input_direction: Vector2 = move_action.value_axis_2d
    grid_move_component.move(input_direction)

    var target_direction = target_action.value_axis_2d
    if not target_direction: return
    target_component.direction = target_direction

func pickup_at(cell) -> Node:
    var pickups: Array[Node] = get_tree().get_nodes_in_group("pickups")
    var found_pickup: Node

    for a_pickup: Pickup in pickups:
        if a_pickup.map_position == cell: found_pickup = a_pickup

    return found_pickup

func set_captured(cell) -> void:
    level.set_cell(cell, 1, Vector2i(number+1, 0))
    captured_cells.append(cell)

func _on_capture_component_successful_capture(cell) -> void:
    set_captured(cell)
    finished_capturing_sound.play()

    var found_pickup: Pickup = pickup_at(cell)
    if not found_pickup: return

    var tween = create_tween()
    tween.tween_callback(func() -> void:
        found_pickup.reveal.emit()
    ).set_delay(finished_capturing_sound.stream.get_length())
