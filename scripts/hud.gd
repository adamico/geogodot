extends CanvasLayer

@onready var player: Node2D = $"../Player"
@onready var character_pos_value: Label = $ColorRect/GridContainer/CharacterPosValue

func _process(delta: float) -> void:
	update_character_position_value(player.get_node("Character").global_position)

func update_character_position_value(value) -> void:
	character_pos_value.text = str(value)
