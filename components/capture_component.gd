class_name CaptureComponent
extends Node

signal successful_capture
signal capture
signal stop_capture

const CROSSHAIR_146 = preload("res://assets/sprites/crosshair146.png")
const CROSSHAIR_008 = preload("res://assets/sprites/crosshair008.png")


@export var capture_progress_bar: ProgressBar
@export var state_chart: StateChart
@export var actor: Node2D
@export var capturing_sound: AudioStreamPlayer
@export var finished_capturing_sound: AudioStreamPlayer
@export var target_component: TargetComponent

var level: TileMapLayer
@export var map_cells_to_capture: Array[Vector2i]

@onready var target_animation_player: AnimationPlayer = %AnimationPlayer
@onready var stats_component: StatsComponent = %StatsComponent


func _ready() -> void:
    _reset_progress_bar()


func _on_capturing_state_processing(delta: float) -> void:
    target_component.texture = CROSSHAIR_146
    target_animation_player.play("capture_target_modulate_pulse")

    capture_progress_bar.show()
    var capture_delta = (50 + stats_component.capture_power * 20) * delta
    if capture_progress_bar.value < 100:
         capture_progress_bar.value += capture_delta
    else:
        state_chart.send_event("finished_capture")


func _on_capturing_state_entered() -> void:
    capturing_sound.play()
    capture.emit()
    state_chart.send_event("prevent_move")
    state_chart.send_event("prevent_target_move")


func _on_capturing_state_exited() -> void:
    stop_capture.emit()
    target_animation_player.stop()
    target_component.texture = CROSSHAIR_008
    capturing_sound.stop()
    _reset_progress_bar()
    state_chart.send_event("allow_move")
    state_chart.send_event("allow_target_move")


func _on_successful_capture_state_entered() -> void:
    successful_capture.emit(map_cells_to_capture)


func _reset_progress_bar() -> void:
    capture_progress_bar.value = 0
    capture_progress_bar.hide()


func on_try_capture() -> void:
    if target_component.direction == Vector2.ZERO: return
    _calculate_cells_to_capture()
    if map_cells_to_capture.is_empty(): return
    state_chart.send_event("capture")


func _calculate_cells_to_capture() -> void:
    var map_cell_to_capture = level.local_to_map(target_component.global_position)

    var already_captured_cells: Array[Vector2i] = actor.captured_cells
    map_cells_to_capture.append(map_cell_to_capture)
    for size in get_tree().get_nodes_in_group("size"):
        map_cells_to_capture.append(level.local_to_map(size.global_position))
    map_cells_to_capture = map_cells_to_capture.filter(
        func(cell): return not already_captured_cells.has(cell)
    )


func on_stop_capturing() -> void:
    state_chart.send_event("stop_capture")
