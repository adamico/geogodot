@tool
class_name RelativeToPlayerModifier
extends GUIDEModifier

var player_coordinates: Vector2


func _modify_input(
    input: Vector3,
     _delta: float,
    _value_type: GUIDEAction.GUIDEActionValueType
) -> Vector3:
    # get mouse input in canvas coordinates
    # (assumes that a canvas modifier is running before this one)	
    var input_as_vector2: Vector2 = Vector2(input.x, input.y)
    # calculate the direction from the player coordinates
    var direction = player_coordinates.direction_to(input_as_vector2)
        
    # return that.
    return Vector3(direction.x, direction.y, 0)


func _editor_name() -> String:
    return "Direction from player"


func _editor_description() -> String:
    return "Calculate a direction from the player."
