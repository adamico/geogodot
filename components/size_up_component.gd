class_name SizeUpComponent
extends PowerUpComponent

func _ready() -> void:
    super()


func _on_picked_up(pickup: Pickup) -> void:
    var current_power_value = stats_component.get(pickup.label_text)
    if current_power_value == Constants.POWER_RANKS: return
    stats_component.call("@" + pickup.label_text + "_setter", current_power_value + 1)
    pickup.queue_free()
