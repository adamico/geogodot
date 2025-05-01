class_name Player
extends Node2D

@warning_ignore("unused_signal")
signal capturing
@warning_ignore("unused_signal")
signal stop_capturing

@export var level: TileMapLayer
@export var move_action: GUIDEAction

var number: int = 0

@onready var grid_move_component: GridMoveComponent = $GridMoveComponent
@onready var capture_component: CaptureComponent = $CaptureComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var flash_component: FlashComponent = $FlashComponent


func _ready() -> void:
	capture_component.level = level
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)
	hurtbox_component.hurt.connect(func(_hitbox_component: HitboxComponent):
		flash_component.flash()
	)

func _process(_delta: float) -> void:
	var input_direction: Vector2 = move_action.value_axis_2d
	grid_move_component.move(input_direction)
