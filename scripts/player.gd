class_name Player

extends Node2D

const GRID_SIZE = 32

@export var speed: float = 100.0
@export var capture: Node2D
@export var state_chart: StateChart
@export var number: int

@onready var sprite: AnimatedSprite2D = $Character/AnimatedSprite2D
@onready var character: Node2D = $Character
@onready var ray_cast_2d: RayCast2D = $Character/RayCast2D
@onready var level: TileMapLayer = $"../World/Level"

@onready var shoot: Node2D = $Shoot

var direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
		sprite.play("move_left")
	elif Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
		sprite.play("move_right")
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP
		sprite.play("move_up")
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
		sprite.play("move_down")
	else:
		direction = Vector2.ZERO
		sprite.play("idle")
	
	if direction != Vector2.ZERO:
		state_chart.send_event("try_move")
	
	if Input.is_action_pressed("capture"):
		var current_map_position: Vector2i = level.local_to_map(
			character.global_position
		)
		var tile_data := level.get_cell_tile_data(current_map_position)
		if tile_data.get_custom_data("owned_by_player") == number: return
		state_chart.send_event("capture")
	
	if Input.is_action_just_released("capture"):
		state_chart.send_event("stop_capturing")

	if Input.is_action_pressed("shoot_left"):
		shoot.direction = Vector2.LEFT
		state_chart.send_event("shoot")
	elif Input.is_action_pressed("shoot_right"):
		shoot.direction = Vector2.RIGHT
		state_chart.send_event("shoot")
	elif Input.is_action_pressed("shoot_up"):
		shoot.direction = Vector2.UP
		state_chart.send_event("shoot")
	elif Input.is_action_pressed("shoot_down"):
		shoot.direction = Vector2.DOWN
		state_chart.send_event("shoot")

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
	
	ray_cast_2d.target_position = direction * GRID_SIZE
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding(): return
	
	state_chart.send_event("move")
	
	character.global_position = level.map_to_local(target_map_position)
	
	sprite.global_position = level.map_to_local(current_map_position)
	capture.global_position = level.map_to_local(current_map_position)
	
func _on_moving_state_processing(delta: float) -> void:
	if character.global_position == sprite.global_position:
		state_chart.send_event("stop_moving")
		return
	
	var target_position = character.global_position
	sprite.global_position = sprite.global_position.move_toward(
		target_position, speed*delta
	)
	capture.global_position = capture.global_position.move_toward(
		target_position, speed*delta
	)

func _on_finish_capturing_state_exited() -> void:
	var current_map_position: Vector2i = level.local_to_map(character.global_position)
	level.set_cell(current_map_position, 1, Vector2i(number, 0))
