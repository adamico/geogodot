extends Node

@export var mapping_context:GUIDEMappingContext
@onready var player: Player = $Player


func _ready() -> void:
	GUIDE.enable_mapping_context(mapping_context)
