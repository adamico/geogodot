extends Node2D

@onready var rig: Node2D = %Rig
@onready var explosion_shape: CollisionShape2D = %ExplosionShape


func _draw() -> void:
    var shape: Shape2D = explosion_shape.shape
    draw_circle(rig.position, shape.get("radius"), Color(1,0,0,0.5))
