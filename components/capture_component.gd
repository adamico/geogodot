class_name CaptureComponent
extends Node

@export var state_chart: StateChart
@export var actor: Node2D
@export var finished_capturing_sound: AudioStreamPlayer
@export var map_cells_to_capture: Array[Vector2i]

var level: TileMapLayer

@onready var stats_component: StatsComponent = %StatsComponent
@onready var capture_cooldown_timer: Timer = %CaptureCooldownTimer
@onready var capture_cooldown_indicator: TextureProgressBar = %CaptureCooldownIndicator


func _ready() -> void:
    capture_cooldown_timer.timeout.connect(_on_capture_cooldown_timer_timeout)


func _process(_delta: float) -> void:
    capture_cooldown_indicator.update_cooldown_indicator(capture_cooldown_timer.time_left)


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
    var cooldown_duration = 3 / (stats_component.capture_power + 1)
    capture_cooldown_timer.start(cooldown_duration)
    capture_cooldown_indicator.start_cooldown(cooldown_duration)


func _on_capture_cooldown_timer_timeout() -> void:
    state_chart.send_event("allow_capture")
    capture_cooldown_indicator.hide_cooldown()


func _calculate_cells_to_capture() -> void:
    var mouse_position = actor.get_global_mouse_position()
    var map_cell_to_capture = level.local_to_map(mouse_position)
    map_cells_to_capture = [map_cell_to_capture]
    map_cells_to_capture = map_cells_to_capture.filter(_not_captured_yet)
    map_cells_to_capture = map_cells_to_capture.filter(_is_capturable_type)


func _not_captured_yet(cell: Vector2i) -> bool:
    var captured_cells = level.captured_cells[actor.capture_faction]
    return not captured_cells.has(cell)


func _is_capturable_type(cell: Vector2i) -> bool:
    var cell_data:= level.get_cell_tile_data(cell)
    return cell_data.get_custom_data("uncaptured")
