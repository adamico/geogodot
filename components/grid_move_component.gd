class_name GridMoveComponent
extends Node2D

signal rammed(other_actor)


@export var actor: Node2D
@export var ray_casts: Node2D
@export var visual_anchor: Marker2D
@export var state_chart: StateChart
@export var speed: float

var direction: Vector2
var level: TileMapLayer

func try_moving(_delta: float) -> void:
	if direction == Vector2.ZERO: return
	
	var current_map_position:= level.local_to_map(
		actor.global_position
	) as Vector2i
	
	var target_map_position:= Vector2i(
		current_map_position.x + int(direction.x), 
		current_map_position.y + int(direction.y)
	)
	
	var tile_data:= level.get_cell_tile_data(target_map_position) as TileData
	
	if not tile_data.get_custom_data("walkable"): return
	
	# TODO: extract to collision component?
	var collisions = ray_casts.get_collisions(direction)
	for collision in collisions:
		rammed.emit(collision)
		break

	actor.global_position = level.map_to_local(target_map_position)
	visual_anchor.global_position = level.map_to_local(current_map_position)
	
	state_chart.send_event("move")

func moving(delta: float) -> void:
	if actor.global_position == visual_anchor.global_position:
		state_chart.send_event("stop_move")
		return
	
	var target_position = actor.global_position
	visual_anchor.global_position = visual_anchor.global_position.move_toward(
		target_position, speed * delta
	)
