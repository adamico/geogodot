class_name Pickup
extends Node2D

@export var label_text: String
@export var level: TileMapLayer

var map_position: Vector2i

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    label.text = label_text
    map_position = level.local_to_map(global_position)
