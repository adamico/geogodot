class_name CaptureComponent
extends Node

const CAPTURE = preload("res://assets/sprites/capture.png")

@export var capture_progress_bar: ProgressBar
@export var state_chart: StateChart
@export var actor: Node2D
@export var capturing_sound: AudioStreamPlayer
@export var finished_capturing_sound: AudioStreamPlayer
@export var target_component: TargetComponent
@export var map_cells_to_capture: Array[Vector2i]

var level: TileMapLayer

@onready var target_animation_player: AnimationPlayer = %AnimationPlayer
@onready var stats_component: StatsComponent = %StatsComponent


func _ready() -> void:
    _reset_progress_bar()


func _on_capturing_state_processing(delta: float) -> void:
    target_animation_player.play("capture_target_modulate_pulse")
    capture_progress_bar.show()
    var capture_delta = (50 + stats_component.capture_power * 20) * delta
    if capture_progress_bar.value < 100:
         capture_progress_bar.value += capture_delta
    else:
        state_chart.send_event("finished_capture")


func _on_capturing_state_entered() -> void:
    capturing_sound.play()
    target_component.texture = CAPTURE
    create_tween().tween_property(target_component, "self_modulate", Color(1,1,1,1), 0.2)
    state_chart.send_event("prevent_move")
    state_chart.send_event("prevent_target_move")


func _on_capturing_state_exited() -> void:
    target_animation_player.stop()
    capturing_sound.stop()
    _reset_progress_bar()
    state_chart.send_event("allow_move")
    state_chart.send_event("allow_target_move")


func _on_successful_capture_state_entered() -> void:
    finished_capturing_sound.play()
    EventBus.captured_tile.emit(map_cells_to_capture, actor.capture_faction)


func _reset_progress_bar() -> void:
    capture_progress_bar.value = 0
    capture_progress_bar.hide()


func on_try_capture() -> void:
    _calculate_cells_to_capture()
    if map_cells_to_capture.is_empty(): return
    state_chart.send_event("capture")


func _calculate_cells_to_capture() -> void:
    var map_cell_to_capture = level.local_to_map(target_component.global_position)
    map_cells_to_capture.append(map_cell_to_capture)
    for size in get_tree().get_nodes_in_group("size"):
        map_cells_to_capture.append(level.local_to_map(size.global_position))
    map_cells_to_capture = map_cells_to_capture.filter(_not_captured_yet)
    map_cells_to_capture = map_cells_to_capture.filter(_is_capturable_type)


func _not_captured_yet(cell: Vector2i) -> bool:
    var captured_cells = level.captured_cells[actor.capture_faction]
    return not captured_cells.has(cell)


func _is_capturable_type(cell: Vector2i) -> bool:
    var cell_data:= level.get_cell_tile_data(cell)
    return cell_data.get_custom_data("uncaptured")


func on_stop_capturing() -> void:
    map_cells_to_capture.clear()
    state_chart.send_event("stop_capture")


func _on_can_capture_state_entered() -> void:
    create_tween().tween_property(target_component, "self_modulate", Color(1,1,1,0), 0.2)
