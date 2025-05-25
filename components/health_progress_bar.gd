class_name HealthBarComponent
extends ProgressBar

@export var stats_component: StatsComponent


func _ready() -> void:
    stats_component.health_changed.connect(func(_actor: Node2D, new_value: float): value = new_value)
