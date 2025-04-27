extends Node2D

@onready var progress_bar: ProgressBar = $ProgressBar
@export var state_chart: StateChart

func _ready() -> void:
	reset_progress_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("capture"):
		state_chart.send_event("capture")
	else:
		state_chart.send_event("stop_capturing")

func _on_capturing_state_processing(delta: float) -> void:
	progress_bar.visible = true
	if progress_bar.value < 100:
		progress_bar.value += 50 * delta
	else:
		state_chart.send_event("successful_capture")

func _on_capturing_state_exited() -> void:
	reset_progress_bar()

func _on_finish_capturing_state_exited() -> void:
	reset_progress_bar()

func reset_progress_bar() -> void:
	progress_bar.value = 0
	progress_bar.visible = false
