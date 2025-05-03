class_name CaptureComponent
extends Node

@export var progress_bar: ProgressBar
@export var state_chart: StateChart
@export var actor: Node2D
@export var capturing: AudioStreamPlayer
@export var finished_capturing: AudioStreamPlayer
@export var target_component: TargetComponent

@onready var target_animation_player: AnimationPlayer = $"../TargetComponent/AnimationPlayer"

const CROSSHAIR_146 = preload("res://assets/sprites/crosshair146.png")
const CROSSHAIR_008 = preload("res://assets/sprites/crosshair008.png")
var level: TileMapLayer
var captured_cells: PackedVector2Array

var map_cell_to_capture: Vector2i

func _ready() -> void:
    reset_progress_bar()

func reset_progress_bar() -> void:
    progress_bar.value = 0
    progress_bar.hide()

func try_capture() -> void:
    if target_component.direction == Vector2.ZERO: return

    var actor_current_map_cell = level.local_to_map(actor.global_position)
    map_cell_to_capture = actor_current_map_cell + Vector2i(
        int(target_component.direction.x),
        int(target_component.direction.y)
    )
    if captured_cells.has(map_cell_to_capture):
        return

    state_chart.send_event("capture")

func _on_capturing_state_processing(delta: float) -> void:
    target_component.texture = CROSSHAIR_146
    target_animation_player.play("capture_target_modulate_pulse")

    progress_bar.show()
    if progress_bar.value < 100:
        progress_bar.value += 50 * delta
    else:
        state_chart.send_event("finished_capture")

func stop_capturing() -> void:
    state_chart.send_event("stop_capture")

func _on_capturing_state_entered() -> void:
    capturing.play()
    actor.capturing.emit()
    state_chart.send_event("prevent_move")

func _on_capturing_state_exited() -> void:
    target_animation_player.stop()
    target_component.texture = CROSSHAIR_008
    capturing.stop()
    reset_progress_bar()
    actor.stop_capturing.emit()
    state_chart.send_event("allow_move")

func _on_successful_capture_state_entered() -> void:
    finished_capturing.play()
    level.set_cell(map_cell_to_capture, 1, Vector2i(actor.number+1, 0))
    captured_cells.append(map_cell_to_capture)
