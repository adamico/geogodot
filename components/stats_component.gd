class_name StatsComponent
extends Node

signal health_changed
signal no_health
signal power_changed
signal power_up
signal power_max


@export var health: = 1.0:
    set(value):
        health = value
        health_changed.emit()
        if health == 0: no_health.emit()

@export var capture_power:= 0:
    set(value):
        capture_power = clampi(value, 0, Constants.MAX_POWER)
        power_changed.emit("capture")
        if capture_power % Constants.POWER_RANKS > 0: return
        if capture_power == 0: return
        if capture_power > Constants.MAX_POWER: return
        if capture_power == Constants.MAX_POWER: power_max.emit("capture")
        else: power_up.emit("capture")

@export var laser_power:= 0:
    set(value):
        laser_power = clampi(value, 0, Constants.MAX_POWER)
        power_changed.emit(name)
        if laser_power % Constants.POWER_RANKS == 0 and laser_power > 0 and laser_power <= Constants.MAX_POWER:
            if laser_power != Constants.MAX_POWER:
                power_up.emit("laser")
            else:
                power_max.emit("laser")
