class_name Pickup
extends Node2D

signal reveal

@export var label_text: String
@export var label_char: String
@export var level: TileMapLayer

var map_position: Vector2i

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    label.text = label_char
    map_position = level.local_to_map(global_position)
    hide_and_disable()
    reveal.connect(_on_reveal)

func hide_and_disable() -> void:
    hide()
    set_process_mode(PROCESS_MODE_DISABLED)

func show_and_enable() -> void:
    show()
    set_process_mode(PROCESS_MODE_INHERIT)

func _on_reveal() -> void:
    show_and_enable()
