@tool
extends Node2D


func _draw() -> void:
    draw_circle(Vector2.ZERO, 8, Color.BLACK, 1.0)


func _process(_delta: float) -> void:
    queue_redraw()
