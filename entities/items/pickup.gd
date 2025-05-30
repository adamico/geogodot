class_name Pickup
extends Node2D

@export var label_text: String


@onready var label: Label = %Label


func _ready() -> void:
    label.text = label_text[0]
    _hide_and_disable()


func _hide_and_disable() -> void:
    hide()
    set_process_mode(PROCESS_MODE_DISABLED)


func _show_and_enable() -> void:
    show()
    set_process_mode(PROCESS_MODE_INHERIT)
