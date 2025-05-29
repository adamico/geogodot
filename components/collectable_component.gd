class_name CollectableComponent
extends Area2D

signal collected(collector)

var pickup

func _ready() -> void:
    collected.connect(_on_collected)


func _on_collected(collector):
    if not collector is CollectorComponent: return
    pickup = get_parent()
    pickup.queue_free()
