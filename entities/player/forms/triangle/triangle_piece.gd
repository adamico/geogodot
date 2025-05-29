@tool
extends Node2D

@export var vertex1: Vector2
@export var vertex2: Vector2
@export var vertex3: Vector2
@export var offset: Vector2
@export var scale_vector: Vector2
@export var fill_color:= Color.MEDIUM_BLUE
@export var edge_color:= Color.ANTIQUE_WHITE

var tri: PackedVector2Array


func _ready() -> void:
    var tri_points: Array = [ vertex1, vertex2, vertex3, vertex1 ]
    tri = scale_points(tri_points)
    position = offset * scale_vector


func _process(delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    draw_set_transform(-offset * scale_vector)
    draw_polygon(tri, [fill_color])
    draw_polyline(tri, edge_color, 0.5, true)


func scale_points(points: Array) -> PackedVector2Array:
    return points.map(func(point): return point * scale_vector)
