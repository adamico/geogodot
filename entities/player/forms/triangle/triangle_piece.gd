@tool
extends Node2D

@export var vertex1:= Vector2(-0.866, -0.50)
@export var vertex2:= Vector2(-0.433, 0.25)
@export var vertex3:= Vector2.ZERO

var tri: PackedVector2Array


func _ready() -> void:
    var scale_value = 20.0

    var tri_points: Array = [ vertex1, vertex2, vertex3, vertex1 ]
    tri = scale_points(tri_points, scale_value)


func _process(delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    var godot_blue : Color = Color("478cbf")
    draw_polygon(tri, [godot_blue])
    draw_polyline(tri, Color.ANTIQUE_WHITE)


func scale_points(points: Array, scale_value) -> PackedVector2Array:
    return points.map(func(point): return point * Vector2(scale_value, scale_value))
