class_name Player
extends Node2D

@export var level:TileMapLayer

var direction: = Vector2.ZERO
var number: int = 0

@onready var input_move_component:InputMoveComponent = $InputMoveComponent
@onready var grid_try_move_component: GridMoveComponent = $GridTryMoveComponent
@onready var direction_value: Label = %DirectionValue
@onready var capture_component: CaptureComponent = $CaptureComponent


func _ready() -> void:
	grid_try_move_component.level = level
	capture_component.level = level

func _process(_delta: float) -> void:
	direction = input_move_component.calculate_direction()
	grid_try_move_component.direction = direction
	update_debug()

func update_debug() -> void:
	direction_value.text = str(direction)
