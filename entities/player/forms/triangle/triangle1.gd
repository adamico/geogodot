@tool
extends Node2D

@export var vertex1:= Vector2(-0.866, -0.5)
@export var vertex2:= Vector2(0.866, -0.5)
@export var vertex3:= Vector2(0, -1.0)
@export var vertex4:= Vector2(-0.433, -0.25)
@export var vertex5:= Vector2(0.433, -0.25)
@export var vertex6:= Vector2(0, 0.5)
@export var stage: int

var tri: PackedVector2Array
var tri2: PackedVector2Array
var tri3: PackedVector2Array

func _ready() -> void:
    var scale_value = 20.0

    var tri_points: Array = [ vertex1, vertex6, vertex4, vertex1 ]
    var tri2_points: Array = [ vertex2, vertex6, vertex5, vertex2 ]
    var tri3_points: Array = [ vertex4, vertex5, vertex3, vertex4 ]

    tri = scale_points(tri_points, scale_value)
    tri2 = scale_points(tri2_points, scale_value)
    tri3 = scale_points(tri3_points, scale_value)



func _process(delta: float) -> void:
    queue_redraw()


func _draw() -> void:
    draw_polygon(tri, [Color.MEDIUM_BLUE])
    draw_polyline(tri, Color.ANTIQUE_WHITE)
    draw_polygon(tri2, [Color.MEDIUM_BLUE])
    draw_polyline(tri2, Color.ANTIQUE_WHITE)
    draw_polygon(tri3, [Color.MEDIUM_BLUE])
    draw_polyline(tri3, Color.ANTIQUE_WHITE)


func scale_points(points: Array, scale_value) -> PackedVector2Array:
    return points.map(func(point): return point * Vector2(scale_value, scale_value))
