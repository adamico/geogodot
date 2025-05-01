extends Node2D

@export var direction: Vector2

@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	move_component.direction = direction
