class_name BaseEnemy
extends Node2D

@export var level:TileMapLayer
@export var grid_move_component: GridMoveComponent
@export var home_position: Vector2

var player: Player
var astar_grid: AStarGrid2D
var path: Array[Vector2i]

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var state_chart: StateChart = $StateChart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = home_position
	astar_grid = setup_astar_grid()
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)
	player = get_tree().get_first_node_in_group("players")
	player.capturing.connect(_on_player_capturing)
	player.stop_capturing.connect(_on_player_stop_capturing)

func setup_astar_grid() -> AStarGrid2D:
	var grid = AStarGrid2D.new()
	grid.region = level.get_used_rect()
	grid.cell_size = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

	return grid

func calculate_path(from, to) -> Array[Vector2i]:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var occupied_positions = []
	
	for enemy in enemies:
		if enemy == self: continue
		occupied_positions.append(level.local_to_map(enemy.global_position))
		
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position)
	
	path = astar_grid.get_id_path(from, to)
	path.pop_front()
	
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	
	return path
	
func _on_calm_state_processing(_delta: float) -> void:
	var from = level.local_to_map(global_position)
	var random_position = Vector2i(randi_range(1,3), randi_range(1,3))
	var to = level.local_to_map(home_position) + random_position
	calculate_path(from, to)

func _on_alerted_state_processing(_delta: float) -> void:
	calculate_path(
		level.local_to_map(global_position),
		level.local_to_map(player.global_position),
	)

func _on_search_state_processing(_delta: float) -> void:
	if path.is_empty():
		state_chart.send_event("no_path")
	else:
		state_chart.send_event("move")

func _on_moving_state_processing(_delta: float) -> void:
	if path.is_empty():
		state_chart.send_event("no_path")
		return
	var target_position = path[0]
	var from = level.local_to_map(global_position)
	var direction: Vector2 = target_position - from
	grid_move_component.move(direction)

func _on_player_capturing() -> void:
	state_chart.send_event("player_is_capturing")
	
func _on_player_stop_capturing() -> void:
	state_chart.send_event("player_stops_capturing")
