class_name CollectorComponent
extends Area2D

@onready var stats_component: StatsComponent = %StatsComponent

func _ready() -> void:
    area_entered.connect(_on_collectable_entered)


func _on_collectable_entered(collectable):
    if not collectable is CollectableComponent: return
    if not collectable.is_visible_in_tree(): return
    collectable.collected.emit(self)

    var current_power_value = stats_component.get(collectable.label_text + "_power")
    var current_power_shards_value = stats_component.get(collectable.label_text + "_power_shards")
    if current_power_value == Constants.POWER_RANKS: return
    stats_component.call("@" + collectable.label_text + "_power_shards_setter", current_power_shards_value + 1)
