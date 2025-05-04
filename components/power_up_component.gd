class_name PowerUpComponent
extends Node

@export var actor: Node2D
@onready var laser: AudioStreamPlayer = $"../Sounds/Laser"
@onready var capture: AudioStreamPlayer = $"../Sounds/Capture"
@onready var up: AudioStreamPlayer = $"../Sounds/Up"


func _ready() -> void:
    actor.picked_up.connect(_on_picked_up)

func _on_picked_up(item: Pickup) -> void:
    var label = item.label_text
    print("picked up ", item.label_text, " pickup at ", item.map_position)
    item.queue_free()

    play_sound_for(label)

func play_sound_for(label) -> void:
    var pickup_sounds: Dictionary = {
        "L": laser,
        "C": capture
    }

    pickup_sounds[label].play()
    create_tween().tween_callback(func() -> void:
        up.play()
    ).set_delay(laser.stream.get_length()-0.2)
