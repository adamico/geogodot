@tool
extends Node2D

@export var scale_factor: float
@export var fill_color: Color
@export var edge_color: Color


func _process(delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    draw_circle(Vector2.ZERO, 1 * scale_factor, fill_color, true, -1)
    draw_circle(Vector2.ZERO, 1 * scale_factor, edge_color, false, 0.5)
