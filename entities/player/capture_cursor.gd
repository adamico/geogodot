extends Node2D

const VALID_CAPTURE_COLOR = Color(0, 0, 0.4, 1)
const INVALID_CAPTURE_COLOR = Color(0.4, 0, 0.2, 1)

@export var line_color: Color

var capture_cooldown_timer: Timer
var can_capture: bool

@onready var line: Line2D = $Line
@onready var line_2: Line2D = $Line2
@onready var line_3: Line2D = $Line3
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _process(_delta: float) -> void:
    if can_capture:
        line_color = VALID_CAPTURE_COLOR
        animation_player.stop()
    else:
        animation_player.play("pulse")
        line_color = INVALID_CAPTURE_COLOR

    for my_line: Line2D in [line, line_2, line_3]:
        my_line.default_color = line_color
