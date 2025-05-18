class_name KamikazeAIComponent
extends BasicAIComponent

@onready var spawner_component: SpawnerComponent = %SpawnerComponent


func _on_area_2d_area_entered(area: Area2D) -> void:
    _explode()


func _explode() -> void:
    spawner_component.spawn()
    actor.call_deferred("queue_free")
    actor.dead.emit()
