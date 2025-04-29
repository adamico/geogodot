extends Node

@export var mapping_context:GUIDEMappingContext
@onready var player: Player = $Player
@onready var hud: Control = $HUD


func _ready() -> void:
	GUIDE.enable_mapping_context(mapping_context)
