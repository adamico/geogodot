class_name Player

extends Node2D

const GRID_SIZE = 32

var direction: Vector2 = Vector2.ZERO
var is_moving := false

@export var speed: float = 1.5
@onready var sprite: AnimatedSprite2D = $Character/AnimatedSprite2D
@onready var character: Sprite2D = $Character
@onready var ray_cast_2d: RayCast2D = $Character/RayCast2D
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"

func _physics_process(_delta: float) -> void:
	if not is_moving: return
	if character.global_position == sprite.global_position:
		is_moving = false
		return
		
	sprite.global_position = sprite.global_position.move_toward(character.global_position, speed)

func _process(_delta: float) -> void:
	if is_moving: return
	
	direction = update_direction()
	move()

func move() -> void:
	var current_map_position: Vector2i = tile_map_layer.local_to_map(character.global_position)
	var target_map_position: Vector2i = Vector2i(
		current_map_position.x + direction.x, 
		current_map_position.y + direction.y
	)
	
	var tile_data := tile_map_layer.get_cell_tile_data(target_map_position)
	if not tile_data.get_custom_data("walkable"): return
	
	ray_cast_2d.target_position = direction * GRID_SIZE
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding(): return
	
	is_moving = true
	
	character.global_position = tile_map_layer.map_to_local(target_map_position)
	sprite.global_position = tile_map_layer.map_to_local(current_map_position)
	
func update_direction() -> Vector2i:
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
	
	return direction
