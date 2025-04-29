extends Control

@onready var percentage_value: Label = %PercentageValue
@onready var score_value: Label = %ScoreValue


func _process(_delta: float) -> void:
	percentage_value.text = "%.1f%%" % Score.current_capture_percentage
	score_value.text = "%04d" % Score.score_values[1]
