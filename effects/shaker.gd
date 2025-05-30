class_name Shaker
extends RefCounted

var target: Node2D
var starting_position: Vector2
var shakes_number := 4


func _init(new_target: Node2D) -> void:
    target = new_target
    starting_position = target.position


func shake(distance: float, duration: float) -> void:
    for i in shakes_number:
        var random_x = randf_range(-distance, distance)
        var random_y = randf_range(-distance, distance)
        var offset = Vector2(random_x, random_y)
        target.position = starting_position + offset
        await target.get_tree().create_timer(duration / shakes_number).timeout
        distance -= (distance / shakes_number)
    target.position = starting_position
