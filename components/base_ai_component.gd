class_name BaseAIComponent
extends Node2D

@export var state_chart: StateChart
@export var level: TileMapLayer


func _ready() -> void:
	pass

### Custom functions
#
#func _on_try_moving_state_processing(_delta: float) -> void:
	#if path.is_empty():
		#state_chart.send_event("no_path")
		#return
	#
	#var original_position = Vector2(global_position)
	#
	#global_position = level.map_to_local(path[0])
	#
	#state_chart.send_event("move")
#
#func _on_moving_state_processing(delta: float) -> void:
	#pass
#
#func _on_stop_moving_state_processing(delta: float) -> void:
	#pass
