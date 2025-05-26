@tool
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    animation_player.play("pulse")


func _draw() -> void:
    draw_circle(Vector2.ZERO, 6, Color.BLACK, 1.0)


func _process(_delta: float) -> void:
    queue_redraw()
