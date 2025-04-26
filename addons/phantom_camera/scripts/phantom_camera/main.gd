class_name Main
extends Node2D

var astar_grid = AStarGrid2D.new()
var grid_size: Vector2i
var cell_size: Vector2i = Data.cell_size
var cell_size_number: int = Data.cell_size_number


func _ready():
	var background = load("res://scenes/background.tscn").instantiate()
	add_child(background)

	var world = load("res://scenes/world/world.tscn").instantiate()
	add_child(world)
  #TODO: add stars in space
	pass


func initialize_grid():
	grid_size = Vector2i(get_viewport_rect().size) / cell_size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.update()


func draw_grid():
	for x in grid_size.x + 1:
		draw_line(Vector2(x * cell_size.x, 0),
			Vector2(x * cell_size.x, grid_size.y * cell_size.y),
			Color.DARK_GRAY, 2.0)
	for y in grid_size.y + 1:
		draw_line(Vector2(0, y * cell_size.y),
			Vector2(grid_size.x * cell_size.x, y * cell_size.y),
			Color.DARK_GRAY, 2.0)
