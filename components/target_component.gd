class_name TargetComponent
extends Sprite2D

@export var tween_position_speed: float

@onready var direction: Vector2


func _ready() -> void:
    direction = Vector2.RIGHT


func _physics_process(_delta: float) -> void:
    create_tween().tween_property(
        self, "position",
        direction * Constants.TILE_SIZE,
        tween_position_speed
    )
