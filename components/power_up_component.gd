class_name PowerUpComponent
extends Node

@export var actor: Node2D
@export var collector_component: CollectorComponent

@onready var laser: AudioStreamPlayer = $"../Sounds/Laser"
@onready var capture: AudioStreamPlayer = $"../Sounds/Capture"
@onready var size: AudioStreamPlayer = $"../Sounds/Size"
@onready var stats_component: StatsComponent = $"../StatsComponent"
@onready var up_sound: AudioStreamPlayer = $"../Sounds/Up"
@onready var max_sound: AudioStreamPlayer = $"../Sounds/Max"


func _ready() -> void:
    stats_component.power_up.connect(_on_stats_component_power_up)
    stats_component.power_max.connect(_on_stats_component_power_max)
    collector_component.picked_up.connect(_on_picked_up)


func _on_picked_up(pickup: Pickup) -> void:
    var current_power_value = stats_component.get(pickup.label_text + "_power")
    var current_power_shards_value = stats_component.get(pickup.label_text + "_power_shards")
    if current_power_value == Constants.POWER_RANKS: return
    stats_component.call("@" + pickup.label_text + "_power_shards_setter", current_power_shards_value + 1)
    pickup.queue_free()


func _on_stats_component_power_up(label) -> void:
    play_sound_for(label, "up")


func _on_stats_component_power_max(label) -> void:
    play_sound_for(label, "max")


func play_sound_for(label, suffix) -> void:
    var pickup_sounds: Dictionary = {
        "laser": laser,
        "capture": capture,
        "size": size
    }

    var sound = pickup_sounds[label]
    sound.play()
    create_tween().tween_callback(func() -> void:
        if suffix == "up": up_sound.play() else: max_sound.play()
    ).set_delay(sound.stream.get_length() * 0.32)


func power_maxed(label) -> bool:
    var current_power_value = stats_component.get(label + "_power")
    return current_power_value == Constants.MAX_POWER
