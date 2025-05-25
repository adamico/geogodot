@tool
extends Node2D


var _o = Vector2.ZERO
var _a = Vector2(-0.866, -0.50)
var _b = Vector2(0.866, -0.50)
var _c = Vector2(0.0, 1)
var _d = Vector2(0, -0.5)
var _e = Vector2(0.433, 0.25)
var _f = Vector2(-0.433, 0.25)

var _time: float = 0
var triangles: Array

var tri1: PackedVector2Array
var tri2: PackedVector2Array
var tri3: PackedVector2Array
var tri4: PackedVector2Array
var tri5: PackedVector2Array
var tri6: PackedVector2Array


func _ready() -> void:
    var scale_value = 20.0

    var tri1_points: Array = [ _a, _f, _o, _a ]
    var tri2_points: Array = [ _a, _d, _o, _a ]
    var tri3_points: Array = [ _b, _e, _o, _b ]
    var tri4_points: Array = [ _b, _d, _o, _b ]
    var tri5_points: Array = [ _c, _f, _o, _c ]
    var tri6_points: Array = [ _c, _e, _o, _c ]
    tri1 = scale_points(tri1_points, scale_value)
    tri2 = scale_points(tri2_points, scale_value)
    tri3 = scale_points(tri3_points, scale_value)
    tri4 = scale_points(tri4_points, scale_value)
    tri5 = scale_points(tri5_points, scale_value)
    tri6 = scale_points(tri6_points, scale_value)


func _draw() -> void:
    var godot_blue : Color = Color("478cbf")
    for tri in triangles:
        draw_polygon(tri, [godot_blue])
        draw_polyline(tri, Color.ANTIQUE_WHITE)


func scale_points(points: Array, scale_value) -> PackedVector2Array:
    return points.map(func(point): return point * Vector2(scale_value, scale_value))
