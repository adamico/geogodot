extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var finished_capturing_sound: AudioStreamPlayer2D = $FinishedCapturing
@onready var capturing_sound: AudioStreamPlayer2D = $Capturing

@export var state_chart: StateChart

func _ready() -> void:
	reset_progress_bar()

func _on_capturing_state_processing(delta: float) -> void:
	progress_bar.visible = true
	if progress_bar.value < 100:
		progress_bar.value += 50 * delta
	else:
		state_chart.send_event("successful_capture")

func _on_capturing_state_exited() -> void:
	capturing_sound.stop()
	reset_progress_bar()

func _on_finish_capturing_state_exited() -> void:
	finished_capturing_sound.play()
	reset_progress_bar()

func reset_progress_bar() -> void:
	progress_bar.value = 0
	progress_bar.visible = false

func _on_capturing_state_entered() -> void:
	capturing_sound.play()
