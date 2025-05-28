@tool
extends Node2D

@export var vertex1: Vector2
@export var vertex2: Vector2
@export var vertex3: Vector2
@export var fill_color: Color
@export var edge_color: Color
@export var scale_vector: Vector2

var tri: PackedVector2Array


func _ready() -> void:
    var tri_points: Array = [ vertex1, vertex2, vertex3, vertex1 ]
    tri = scale_points(tri_points)


func _process(delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    draw_polygon(tri, [fill_color])
    draw_polyline(tri, edge_color)


func scale_points(points: Array) -> PackedVector2Array:
    return points.map(func(point): return point * scale_vector)
