class_name Player
extends Node2D

@warning_ignore("unused_signal")
signal capturing
@warning_ignore("unused_signal")
signal stop_capturing

@export var level: TileMapLayer
@export var move_action: GUIDEAction
@export var capture_action: GUIDEAction
@export var shoot_action: GUIDEAction
@export var target_action: GUIDEAction

var number: int = 0
var target_direction: Vector2

@onready var grid_move_component: GridMoveComponent = $GridMoveComponent
@onready var capture_component: CaptureComponent = $CaptureComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shoot_component: ShootComponent = $ShootComponent

func _ready() -> void:
	capture_component.level = level
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)
	hurtbox_component.hurt.connect(func(_hitbox_component: HitboxComponent):
		flash_component.flash()
	)
	capture_action.triggered.connect(capture_component.try_capture)
	capture_action.completed.connect(capture_component.stop_capturing)
	show_sprite(false)
	target_action.triggered.connect(show_sprite.bind(true))
	target_action.completed.connect(show_sprite.bind(false))
	shoot_action.triggered.connect(shoot_component.fire_laser)

func _process(_delta: float) -> void:
	var input_direction: Vector2 = move_action.value_axis_2d
	grid_move_component.move(input_direction)
	shoot_component.target_direction = target_action.value_axis_2d

func show_sprite(must_show: bool) -> void:
	shoot_component.target_sprite.visible = must_show
