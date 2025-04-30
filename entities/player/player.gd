class_name Player
extends AnimatedSprite2D

@export var level:TileMapLayer
@export var move_action: GUIDEAction

var number: int = 0
@onready var grid_move_component: GridMoveComponent = $GridMoveComponent
@onready var capture_component: CaptureComponent = $CaptureComponent

func _ready() -> void:
	grid_move_component.level = level
	capture_component.level = level
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)


func _process(_delta: float) -> void:
	var input_direction: Vector2 = move_action.value_axis_2d
	grid_move_component.move(input_direction)
