extends Node2D

const GRID_SIZE = 32

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = $"../../../Player/Character"
@onready var level: TileMapLayer = $"../../Level"

#TODO: add state chart for enemies
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
		occupied_positions.append(level.local_to_map(enemy.global_position))
		
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position)
	
	var from = level.local_to_map(global_position)
	var to = level.local_to_map(player.global_position)
	var path = astar_grid.get_id_path(from, to)
	
	path.pop_front()
	
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
	
	if path.is_empty() or path.size() == 1: return
	
	var original_position = Vector2(global_position)
	
	global_position = level.map_to_local(path[0])
	sprite.global_position = original_position
	
	is_moving = true

func setup_astar_grid() -> AStarGrid2D:
	var grid = AStarGrid2D.new()
	grid.region = level.get_used_rect()
	grid.cell_size = Vector2(GRID_SIZE, GRID_SIZE)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

	return grid


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"): return
	area.get_parent().queue_free()
	queue_free()
