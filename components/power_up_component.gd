class_name PowerUpComponent
extends Node

@export var actor: Node2D
@onready var laser: AudioStreamPlayer = $"../Sounds/Laser"
@onready var capture: AudioStreamPlayer = $"../Sounds/Capture"
@onready var up: AudioStreamPlayer = $"../Sounds/Up"
@onready var stats_component: StatsComponent = $"../StatsComponent"

func _ready() -> void:
    actor.picked_up.connect(_on_picked_up)
    stats_component.power_up.connect(_on_stats_component_power_up)

func _on_picked_up(item: Pickup) -> void:
    var current_power_value = stats_component.get(item.label_text + "_power")
    stats_component.call("@" + item.label_text + "_power" + "_setter", current_power_value + 1)
    item.queue_free()

func _on_stats_component_power_up(label) -> void:
    play_sound_for(label)

func play_sound_for(label) -> void:
    var pickup_sounds: Dictionary = {
        "laser": laser,
        "capture": capture
    }

    pickup_sounds[label].play()
    create_tween().tween_callback(func() -> void:
        up.play()
    ).set_delay(laser.stream.get_length()-0.2)
