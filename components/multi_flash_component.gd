class_name MultiFlashComponent
extends FlashComponent

@export var sprite_parent: Node2D

var sprites: Array[Node]

func _ready() -> void:
    add_child(timer)
    sprites = sprite_parent.get_children()
    for sprite in sprites:
        original_sprite_material = sprite.material


func flash() -> void:
    for sprite in sprites:
        sprite.material = flash_material
    timer.start(flash_duration)
    await timer.timeout
    for sprite in sprites:
        sprite.material = original_sprite_material
        sprite.queue_redraw()
