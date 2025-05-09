class_name CollectorComponent
extends Area2D

signal picked_up(pickup)


func _ready() -> void:
    area_entered.connect(_on_collectable_entered)


func _on_collectable_entered(collectable):
    if not collectable is CollectableComponent: return
    if not collectable.is_visible_in_tree(): return
    collectable.collected.emit(self)
