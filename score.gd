extends Node

var current_capture_percentage: float = 0.0
var cells_total: int = 30*30
var captured_cells: Array[int] = [0, 0, 0, 0]

var score_values: Array[int] = [0, 0, 0, 0]

func update_capture_percentage(player_number, multiplier) -> void:
	var current_number_of_cells_for_player = captured_cells[player_number]
	var new_number_of_cells_for_player = current_number_of_cells_for_player + 1 * multiplier
	captured_cells[player_number] = new_number_of_cells_for_player
	current_capture_percentage = (captured_cells[player_number] / (cells_total * 1.0)) * 100

func update_score_values(player_number, amount) -> void:
	var current_score_for_player = score_values[player_number]
	var new_score_for_player = current_score_for_player + amount
	score_values[player_number] = new_score_for_player 
