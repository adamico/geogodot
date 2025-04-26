extends Node

var level: int = randi_range(1,4)

var cell_size_number: int = 64
var cell_size = Vector2i(cell_size_number, cell_size_number)
var captured_cells : Array = [[], [], [], []]

const PLAYER_COLORS := [
	Color(0, 0, 1, 0.5),
	Color(1, 0, 0, 0.5),
	Color(0, 1, 0, 0.5),
	Color(0.78, 0.78, 0, 0.5)
]

func set_captured_cell_for_player(player_number: int, pos: Vector2i) -> void:
	var cell = cell_coords(pos)
	captured_cells[player_number - 1].append(cell)


func get_captured_cells_for_player(player_number: int) -> Array:
	return captured_cells[player_number - 1]


func cell_coords(pos: Vector2i):
	var x = pos.x
	var y = pos.y
	return Vector2i(pos.x/cell_size.x, pos.y/cell_size.y)
