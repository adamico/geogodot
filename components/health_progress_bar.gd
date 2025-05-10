class_name HealthBarComponent
extends ProgressBar

@export var stats_component: StatsComponent


func _ready() -> void:
    stats_component.health_changed.connect(func(health_value: float):
            value = health_value)
