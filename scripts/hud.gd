extends CanvasLayer

@onready var player: Node2D = $"../Player"
@onready var character_pos_value: Label = $ColorRect/GridContainer/CharacterPosValue
@onready var sprite_pos_value: Label = $ColorRect/GridContainer/SpritePosValue
@onready var shoot_timer_value: Label = $ColorRect/GridContainer/ShootTimerValue

func _process(delta: float) -> void:
	update_character_position_value(player.get_node("Character").global_position)
	update_sprite_position_value(player.get_node("Character/AnimatedSprite2D").global_position)
	update_shoot_timer_value(player.get_node("Shoot/Timer").time_left)

func update_character_position_value(value) -> void:
	character_pos_value.text = str(value)

func update_sprite_position_value(value) -> void:
	sprite_pos_value.text = str(value)

func update_shoot_timer_value(value) -> void:
	shoot_timer_value.text = str(value)	
