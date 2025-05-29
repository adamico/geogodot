@tool
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var scale_factor:= 20.0
@export var fill_color:= Color.BLACK
@export var edge_color:= Color.ANTIQUE_WHITE

func _ready() -> void:
    animation_player.play("pulse")


func _draw() -> void:
    draw_circle(Vector2.ZERO, 1 * scale_factor, fill_color, 1.0)


func _process(_delta: float) -> void:
    queue_redraw()
