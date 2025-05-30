class_name CaptureComponent
extends Node

const CAPTURE_CURSOR_SCENE = preload("res://entities/player/capture_cursor.tscn")

@export var state_chart: StateChart
@export var actor: Node2D
@export var finished_capturing_sound: AudioStreamPlayer
@export var map_cells_to_capture: Array[Vector2i]
@export var capture_reach:= 3.0

var level: TileMapLayer
var _capture_cursor_node: Node2D = null
var _last_cursor_cell: Vector2i = Vector2i(-1, -1)

@onready var stats_component: StatsComponent = %StatsComponent
@onready var capture_cooldown_timer: Timer = %CaptureCooldownTimer
@onready var capture_cooldown_indicator: TextureProgressBar = %CaptureCooldownIndicator


func _ready() -> void:
    capture_cooldown_timer.timeout.connect(_on_capture_cooldown_timer_timeout)
    _instantiate_capture_cursor()


func _process(_delta: float) -> void:
    capture_cooldown_indicator.update_cooldown_indicator(capture_cooldown_timer.time_left)
    show_capture_cursor()


func _instantiate_capture_cursor() -> void:
    _capture_cursor_node = CAPTURE_CURSOR_SCENE.instantiate()
    get_tree().current_scene.add_child.call_deferred(_capture_cursor_node)


func show_capture_cursor() -> void:
    var mouse_world_position = actor.get_global_mouse_position()
    var current_cell = level.local_to_map(mouse_world_position)

    if _last_cursor_cell == current_cell:
        return

    _last_cursor_cell = current_cell
    _capture_cursor_node.can_capture = _is_valid_capturable_cell(current_cell) and capture_cooldown_timer.is_stopped()

    var final_cursor_global_position = level.map_to_local(current_cell)
    create_tween().tween_property(_capture_cursor_node, "global_position", final_cursor_global_position, 0.1)


func try_capture() -> void:
    _calculate_cells_to_capture()
    if map_cells_to_capture.is_empty():
        return
    if not capture_cooldown_timer.is_stopped():
        return
    _capture()


func _capture() -> void:
    state_chart.send_event("capture")
    finished_capturing_sound.play()
    EventBus.captured_tile.emit(map_cells_to_capture, actor.capture_faction)
    var cooldown_duration: float = 3.0 / (stats_component.capture_power + 1)
    capture_cooldown_timer.start(cooldown_duration)
    _capture_cursor_node.can_capture = false
    capture_cooldown_indicator.start_cooldown(cooldown_duration)


func _on_capture_cooldown_timer_timeout() -> void:
    state_chart.send_event("allow_capture")
    _capture_cursor_node.can_capture = true
    capture_cooldown_indicator.hide_cooldown()


func _calculate_cells_to_capture() -> void:
    var map_cell_to_capture = level.local_to_map(actor.get_global_mouse_position())
    map_cells_to_capture = [map_cell_to_capture]
    map_cells_to_capture = map_cells_to_capture.filter(_is_valid_capturable_cell)


func _is_valid_capturable_cell(cell: Vector2i) -> bool:
    if not _is_inside_level(cell):
        return false
    return _is_capturable_type(cell) and _not_captured_yet(cell) and _is_in_capture_range(cell)


func _is_in_capture_range(cell: Vector2i) -> bool:
    var total_capture_reach = capture_reach + stats_component.capture_power
    return cell.distance_to(level.local_to_map(actor.global_position)) <= total_capture_reach


func _is_inside_level(cell: Vector2i) -> bool:
    return level.get_used_rect().has_point(cell)


func _not_captured_yet(cell: Vector2i) -> bool:
    return not level.captured_cells[actor.capture_faction].has(cell)


func _is_capturable_type(cell: Vector2i) -> bool:
    return level.get_cell_tile_data(cell).get_custom_data("uncaptured")
