class_name FlashComponent
extends Node

@export var flash_material: Material
@export var sprite: Node2D
@export var flash_duration := 0.2

var original_sprite_material: Material
var timer: Timer = Timer.new()


func _ready() -> void:
    add_child(timer)
    original_sprite_material = sprite.material


func flash() -> void:
    sprite.material = flash_material
    timer.start(flash_duration)
    await timer.timeout
    sprite.material = original_sprite_material
    sprite.queue_redraw()
