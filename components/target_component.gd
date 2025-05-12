class_name TargetComponent
extends Sprite2D

var old_direction: Vector2

@onready var direction: Vector2
@onready var cannot_move_target: AtomicState = %CannotMoveTarget
@onready var can_move_target: AtomicState = %CanMoveTarget


func _ready() -> void:
    direction = Vector2.RIGHT
    cannot_move_target.state_processing.connect(_on_cannot_move_target)
    can_move_target.state_processing.connect(_on_can_move_target)


func _on_can_move_target(_delta: float) -> void:
    position = direction * Constants.TILE_SIZE
    old_direction = direction


func _on_cannot_move_target(_delta: float) -> void:
    direction = old_direction
