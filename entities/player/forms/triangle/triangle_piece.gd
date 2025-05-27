@tool
extends Node2D

@export var vertex1: Vector2
@export var vertex2: Vector2
@export var vertex3: Vector2
@export var offset:= Vector2(-0.433, 0.25)
var scale_vector:= Vector2(20.0, 20.0)
var tri: PackedVector2Array


func _ready() -> void:
    var tri_points: Array = [ vertex1, vertex2, vertex3, vertex1 ]
    tri = scale_points(tri_points)
    position = offset * scale_vector


func _process(delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    draw_set_transform(-offset * scale_vector)
    draw_polygon(tri, [Color.MEDIUM_BLUE])
    draw_polyline(tri, Color.ANTIQUE_WHITE)


func scale_points(points: Array) -> PackedVector2Array:
    return points.map(func(point): return point * scale_vector)
