class_name MultiFlashComponent
extends Node

@export var flash_material: Material
@export var sprite_parent: Node2D
@export var flash_duration := 0.2

var original_sprite_material: Material
var sprites: Array[Node]
var timer: Timer = Timer.new()


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
