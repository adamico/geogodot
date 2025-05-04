class_name Player
extends Node2D

@warning_ignore("unused_signal")
signal capturing
@warning_ignore("unused_signal")
signal stop_capturing
signal picked_up(item)

@export var level: TileMapLayer
@export var capture_action: GUIDEAction
@export var move_action: GUIDEAction
@export var shoot_action: GUIDEAction
@export var target_action: GUIDEAction
@export var number: int

@onready var capture_component: CaptureComponent = $CaptureComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var grid_move_component: GridMoveComponent = $GridMoveComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var shoot_component: ShootComponent = $ShootComponent
@onready var target_component: TargetComponent = $TargetComponent

func _ready() -> void:
    position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
    position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)

    hurtbox_component.hurt.connect(func(_hitbox_component: HitboxComponent):
        flash_component.flash()
    )

    capture_component.level = level
    capture_action.triggered.connect(capture_component.try_capture)
    capture_action.completed.connect(capture_component.stop_capturing)

    shoot_action.triggered.connect(shoot_component.fire_laser)
    shoot_action.completed.connect(shoot_component.stop_firing)

    picked_up.connect(_on_picked_up)

func _process(_delta: float) -> void:
    var input_direction: Vector2 = move_action.value_axis_2d
    grid_move_component.move(input_direction)

    var target_direction = target_action.value_axis_2d
    if not target_direction: return
    target_component.direction = target_direction

func _on_picked_up(item) -> void:
    print("picked up ", item.label_text, " pickup at ", item.map_position)
