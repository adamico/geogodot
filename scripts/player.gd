extends Node2D
class_name Player

#TODO: move this to a global autoload
const GRID_SIZE = 32

@export var speed: float = 100.0
@export var capture: Node2D
@export var level: TileMapLayer
@export var state_chart: StateChart
@export var number: int
@export var shoot: Node2D
@export var move_action:GUIDEAction
@export var capture_action:GUIDEAction
@export var shoot_action:GUIDEAction

@onready var sprite: AnimatedSprite2D = $Character/AnimatedSprite2D
@onready var character: Node2D = $Character
@onready var ray_casts: Node2D = $Character/AnimatedSprite2D/RayCasts

var direction := Vector2.ZERO
var last_direction := Vector2.ZERO
var captured_cells: PackedVector2Array

signal died
signal capturing
signal stop_capturing


### Native functions
func _ready() -> void:
	died.connect(_on_death)
	add_to_group("players")
	
	capture_action.triggered.connect(_on_capture_action_triggered)
	capture_action.completed.connect(_on_capture_action_completed)

func _process(_delta: float) -> void:
	direction = move_action.value_axis_2d
	var diagonals = [Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)]
	if diagonals.find(direction) != -1: direction = last_direction
	if direction != Vector2.ZERO: state_chart.send_event("try_move")
	last_direction = direction
	
	shoot.direction = shoot_action.value_axis_2d
	if shoot.direction != Vector2.ZERO: state_chart.send_event("shoot")


func play_animation() -> void:
	var directions_to_sprites: Dictionary = {
		Vector2.LEFT: "move_left",
		Vector2.RIGHT: "move_right",
		Vector2.UP: "move_up",
		Vector2.DOWN: "move_down",
		Vector2.ZERO: "idle"
	}
	sprite.play(directions_to_sprites[direction])


func ram(target: Area2D) -> void:
	var enemy = target.get_node("../..")
	enemy.died.emit()
	
	
### Signal Callbacks
func _on_try_moving_state_processing(_delta: float) -> void:
	var current_map_position: Vector2i = level.local_to_map(
		character.global_position
	)
	var target_map_position: Vector2i = Vector2i(
		current_map_position.x + direction.x, 
		current_map_position.y + direction.y
	)
	
	var tile_data := level.get_cell_tile_data(target_map_position)
	if not tile_data.get_custom_data("walkable"): return
	
	if direction != Vector2.ZERO:
		var collisions = ray_casts.get_collisions(direction)
		for collision in collisions:
			ram(collision)
	
	state_chart.send_event("move")
	
	character.global_position = level.map_to_local(target_map_position)
	
	sprite.global_position = level.map_to_local(current_map_position)
	capture.global_position = level.map_to_local(current_map_position)
	
	
func _on_moving_state_processing(delta: float) -> void:
	if character.global_position == sprite.global_position:
		state_chart.send_event("stop_moving")
		return
	
	play_animation()
	
	var target_position = character.global_position
	sprite.global_position = sprite.global_position.move_toward(
		target_position, speed*delta
	)
	capture.global_position = capture.global_position.move_toward(
		target_position, speed*delta
	)


func _on_finish_capturing_state_exited() -> void:
	var current_map_position: Vector2i = level.local_to_map(
		character.global_position
	)
	level.set_cell(current_map_position, 1, Vector2i(number, 0))
	captured_cells.append(current_map_position)


func _on_death() -> void:
	pass


func _on_capture_capturing() -> void:
	capturing.emit()


func _on_capture_stop_capturing() -> void:
	stop_capturing.emit()
	
	

func _on_capture_action_triggered() -> void:
	var current_map_position: Vector2i = level.local_to_map(
			character.global_position
		)
	if captured_cells.has(current_map_position): return
	
	state_chart.send_event("capture")
	

func _on_capture_action_completed() -> void:
	state_chart.send_event("stop_capturing")
