class_name CaptureComponent
extends Node

signal successful_capture
signal capture
signal stop_capture

@export var capture_progress_bar: ProgressBar
@export var state_chart: StateChart
@export var actor: Node2D
@export var capturing_sound: AudioStreamPlayer
@export var finished_capturing_sound: AudioStreamPlayer
@export var target_component: TargetComponent

@onready var stats_component: StatsComponent = $"../StatsComponent"
@onready var target_animation_player: AnimationPlayer = $"../TargetComponent/AnimationPlayer"

const CROSSHAIR_146 = preload("res://assets/sprites/crosshair146.png")
const CROSSHAIR_008 = preload("res://assets/sprites/crosshair008.png")
var level: TileMapLayer

var map_cell_to_capture: Vector2i

func _ready() -> void:
    reset_progress_bar()

func reset_progress_bar() -> void:
    capture_progress_bar.value = 0
    capture_progress_bar.hide()

func try_capture() -> void:
    if target_component.direction == Vector2.ZERO: return

    var actor_current_map_cell = level.local_to_map(actor.global_position)
    map_cell_to_capture = actor_current_map_cell + Vector2i(
        int(target_component.direction.x),
        int(target_component.direction.y)
    )
    if actor.captured_cells.has(map_cell_to_capture): return

    state_chart.send_event("capture")

func stop_capturing() -> void:
    state_chart.send_event("stop_capture")

func _on_capturing_state_processing(delta: float) -> void:
    target_component.texture = CROSSHAIR_146
    target_animation_player.play("capture_target_modulate_pulse")

    capture_progress_bar.show()
    if capture_progress_bar.value < 100:
         capture_progress_bar.value += (50 + stats_component.capture_power/Constants.POWER_RANKS * 60) * delta
    else:
        state_chart.send_event("finished_capture")

func _on_capturing_state_entered() -> void:
    capturing_sound.play()
    capture.emit()
    state_chart.send_event("prevent_move")

func _on_capturing_state_exited() -> void:
    stop_capture.emit()
    target_animation_player.stop()
    target_component.texture = CROSSHAIR_008
    capturing_sound.stop()
    reset_progress_bar()
    state_chart.send_event("allow_move")

func _on_successful_capture_state_entered() -> void:
    successful_capture.emit(map_cell_to_capture)
