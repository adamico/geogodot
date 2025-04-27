extends CanvasLayer

@onready var player: Node2D = $"../Player"
@onready var character_pos_value: Label = $ColorRect/GridContainer/CharacterPosValue
@onready var sprite_pos_value: Label = $ColorRect/GridContainer/SpritePosValue

func _process(delta: float) -> void:
	update_character_position_value(player.get_node("Character").global_position)
	update_sprite_position_value(player.get_node("Character/AnimatedSprite2D").global_position)

func update_character_position_value(value) -> void:
	character_pos_value.text = str(value)

func update_sprite_position_value(value) -> void:
	sprite_pos_value.text = str(value)
