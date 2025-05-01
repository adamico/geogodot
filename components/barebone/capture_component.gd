class_name CaptureComponent
extends Node

@export var progress_bar: ProgressBar
@export var capture_action: GUIDEAction
@export var state_chart: StateChart
@export var actor: Node2D

var level: TileMapLayer
var captured_cells: PackedVector2Array

@onready var finished_capturing: AudioStreamPlayer = $FinishedCapturing
@onready var capturing: AudioStreamPlayer = $Capturing

func _ready() -> void:
	reset_progress_bar()
	capture_action.triggered.connect(try_capture)
	capture_action.completed.connect(stop_capturing)

func reset_progress_bar() -> void:
	progress_bar.value = 0
	progress_bar.hide()

func try_capture() -> void:
	var current_map_position: Vector2i = level.local_to_map(
		actor.global_position
	)
	if captured_cells.has(current_map_position): return
	
	state_chart.send_event("capture")

func capture(delta: float) -> void:
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
	state_chart.send_event("prevent_shoot")
	state_chart.send_event("prevent_move")

func _on_capturing_state_exited() -> void:
	capturing.stop()
	reset_progress_bar()
	actor.stop_capturing.emit()
	state_chart.send_event("allow_move")
	state_chart.send_event("allow_shoot")

func _on_successful_capture_state_entered() -> void:
	finished_capturing.play()
	var current_map_position: Vector2i = level.local_to_map(
		actor.global_position
	)
	level.set_cell(current_map_position, 1, Vector2i(actor.number+1, 0))
	captured_cells.append(current_map_position)
