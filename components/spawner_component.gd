class_name SpawnerComponent
extends Node2D

@export var scene: PackedScene


func spawn(
        spawn_global_position: Vector2 = global_position,
        parent: Node = get_tree().current_scene
) -> Node:
    assert(scene is PackedScene,
            "Error: the scene export was never set on this spawner component")
    var instance: Node2D = scene.instantiate()
    instance.global_position = spawn_global_position
    parent.add_child(instance)

    return instance
