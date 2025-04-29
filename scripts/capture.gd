extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var finished_capturing_sound: AudioStreamPlayer2D = $FinishedCapturing
@onready var capturing_sound: AudioStreamPlayer2D = $Capturing

var state_chart: StateChart

signal capturing
signal stop_capturing

### Native functions
func _ready() -> void:
	state_chart = get_parent().get_node("StateChart")
	reset_progress_bar()


### Custom functions
func reset_progress_bar() -> void:
	progress_bar.value = 0
	progress_bar.visible = false


### Signal Callbacks

func _on_capturing_state_entered() -> void:
	capturing.emit()
	state_chart.send_event("prevent_shoot")
	state_chart.send_event("prevent_move")
	capturing_sound.play()

func _on_capturing_state_processing(delta: float) -> void:
	progress_bar.visible = true
	if progress_bar.value < 100:
		progress_bar.value += 50 * delta
	else:
		state_chart.send_event("successful_capture")

func _on_capturing_state_exited() -> void:
	capturing_sound.stop()
	reset_progress_bar()
	state_chart.send_event("allow_shoot")
	state_chart.send_event("allow_move")
	stop_capturing.emit()

func _on_finish_capturing_state_exited() -> void:
	finished_capturing_sound.play()
	reset_progress_bar()
	state_chart.send_event("allow_shoot")
	state_chart.send_event("allow_move")
	stop_capturing.emit()
