class_name SpawnerComponent
extends Node2D

@export var scene: PackedScene
@export var scene_scale: Vector2

func spawn(spawn_position: Vector2 = global_position, parent: Node = get_tree().current_scene) -> void:
    assert(scene is PackedScene,
            "Error: the scene export was never set on this spawner component")
    var instance: Node2D = scene.instantiate()
    instance.scale = scene_scale
    instance.global_position = spawn_position
    parent.add_child(instance)
