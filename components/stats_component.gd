class_name StatsComponent
extends Node

signal health_changed
signal no_health
signal power_up
signal power_changed

@export var health: = 1.0:
    set(value):
        health = value
        health_changed.emit()
        if health == 0: no_health.emit()

@export var capture_power:= 1:
    set(value):
        capture_power = value
        power_changed.emit("capture")
        if capture_power % 3 == 0:
            power_up.emit("capture")

@export var laser_power:= 1:
    set(value):
        laser_power = value
        power_changed.emit("laser")
        if laser_power % 3 == 0:
            power_up.emit("laser")
