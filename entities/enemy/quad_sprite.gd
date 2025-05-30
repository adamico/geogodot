@tool
extends Node2D

@export var vertex1: Vector2
@export var vertex2: Vector2
@export var vertex3: Vector2
@export var vertex4: Vector2
@export var scale_vector: Vector2
@export var fill_color: Color
@export var edge_color: Color
@export var edge_width: float

var shape: PackedVector2Array


func _ready() -> void:
    var shape_points: Array = [ vertex1, vertex2, vertex3, vertex4, vertex1 ]
    shape = scale_points(shape_points)


func _process(_delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    draw_polygon(shape, [fill_color])
    draw_polyline(shape, edge_color, edge_width, true)


func scale_points(points: Array) -> PackedVector2Array:
    return points.map(func(point): return point * scale_vector)
