class_name Pickup
extends Node2D

signal reveal

@export var label_text: String

var map_position: Vector2i

@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
    label.text = label_text[0]
    _hide_and_disable()


func _hide_and_disable() -> void:
    hide()
    set_process_mode(PROCESS_MODE_DISABLED)


func _show_and_enable() -> void:
    show()
    set_process_mode(PROCESS_MODE_INHERIT)


func _on_reveal() -> void:
    _show_and_enable()
