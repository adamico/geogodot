class_name PowerUpComponent
extends Node

signal size_up

@export var actor: Node2D

@onready var laser: AudioStreamPlayer = %Laser
@onready var capture: AudioStreamPlayer = %Capture
@onready var size: AudioStreamPlayer = %Size
@onready var stats_component: StatsComponent = %StatsComponent
@onready var up_sound: AudioStreamPlayer = %Up
@onready var max_sound: AudioStreamPlayer = %Max


func _ready() -> void:
    stats_component.power_up.connect(_on_stats_component_power_up)
    stats_component.power_max.connect(_on_stats_component_power_max)


func _on_stats_component_power_up(label) -> void:
    _play_sound_for(label, "up")
    if label == "size": size_up.emit()


func _on_stats_component_power_max(label) -> void:
    _play_sound_for(label, "max")
    if label == "size": size_up.emit()


func _play_sound_for(label, suffix) -> void:
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
