class_name CollectableComponent
extends Area2D

signal collected(collector)


func _ready() -> void:
    collected.connect(_on_collected)


func _on_collected(collector):
    var pick_up = get_parent()
    if not collector is CollectorComponent: return
    collector.picked_up.emit(pick_up)
