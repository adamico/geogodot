class_name InputMoveComponent
extends Node
## Process inputs to feed the MoveComponent

@export var move_action:GUIDEAction
@export var state_chart:StateChart

var last_direction:= Vector2.ZERO

func calculate_direction() -> Vector2:
	var direction = move_action.value_axis_2d
	var diagonals = [
		Vector2(1,1), Vector2(-1,1),
		Vector2(1,-1), Vector2(-1,-1)
	]
	
	if diagonals.find(direction) != -1:
		direction = last_direction
	if direction != Vector2.ZERO:
		state_chart.send_event("input_direction")

	last_direction = direction
	return direction
