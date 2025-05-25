@tool
extends Node2D


func _draw() -> void:
    draw_rect(Rect2(-10, -10, 20, 20), Color.BLUE)


func _process(delta: float) -> void:
    queue_redraw()
