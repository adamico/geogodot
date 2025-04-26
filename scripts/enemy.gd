extends Node2D

const GRID_SIZE = 32

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Sprite2D = $"../Player/Character"
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

var astar_grid: AStarGrid2D
var is_moving : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_grid = setup_astar_grid()

func _physics_process(_delta: float) -> void:
	if is_moving:
		sprite.global_position = sprite.global_position.move_toward(global_position, 1)
		if sprite.global_position != global_position: return
	
	is_moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_moving: return
	move()

func move() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var occupied_positions = []
	
	for enemy in enemies:
		if enemy == self: continue
		occupied_positions.append(tile_map_layer.local_to_map(enemy.global_position))
		
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position)
	
	var from = tile_map_layer.local_to_map(global_position)
	var to = tile_map_layer.local_to_map(player.global_position)
	var path = astar_grid.get_id_path(from, to)
	
	path.pop_front()
	
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	
	if path.is_empty() or path.size() == 1: return
	
	var original_position = Vector2(global_position)
	
	global_position = tile_map_layer.map_to_local(path[0])
	sprite.global_position = original_position
	
	is_moving = true

func setup_astar_grid() -> AStarGrid2D:
	var grid = AStarGrid2D.new()
	grid.region = tile_map_layer.get_used_rect()
	grid.cell_size = Vector2(GRID_SIZE, GRID_SIZE)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

	return grid
