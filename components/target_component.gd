class_name TargetComponent
extends Sprite2D


var target_direction: Vector2

func _process(_delta: float) -> void:
	position = target_direction * 32
