class_name StatsComponent
extends Node

signal power_up
signal power_max
signal health_changed

@export var actor: Node2D

@export var health := 1.0:
    set(value):
        health = value
        health_changed.emit(actor, value)
        if health <= 0: EventBus.actor_died.emit(actor)

@export var capture_power := 0:
    set(value):
        capture_power = clampi(value, 0, Constants.POWER_RANKS)
        if capture_power == 0: return
        if capture_power > Constants.POWER_RANKS: return
        if capture_power == Constants.POWER_RANKS: power_max.emit("capture")
        else: power_up.emit("capture")

@export var laser_power := 0:
    set(value):
        laser_power = clampi(value, 0, Constants.POWER_RANKS)
        if laser_power == 0: return
        if laser_power > Constants.POWER_RANKS: return
        if laser_power == Constants.POWER_RANKS: power_max.emit("laser")
        else: power_up.emit("laser")

@export var size_power := 0:
    set(value):
        size_power = clampi(value, 0, Constants.POWER_RANKS)
        if size_power == 0: return
        if size_power > Constants.POWER_RANKS: return
        if size_power == Constants.POWER_RANKS: power_max.emit("size")
        else: power_up.emit("size")

@export var size_power_shards := 0:
    set(value):
        size_power_shards = clampi(value, 0, Constants.POWER_SHARDS)
        if size_power_shards == Constants.POWER_SHARDS:
            size_power += 1
            size_power_shards = 0

@export var capture_power_shards := 0:
    set(value):
        capture_power_shards = clampi(value, 0, Constants.POWER_SHARDS)
        if capture_power_shards == Constants.POWER_SHARDS:
            capture_power += 1
            capture_power_shards = 0

@export var laser_power_shards := 0:
    set(value):
        laser_power_shards = clampi(value, 0, Constants.POWER_SHARDS)
        if laser_power_shards == Constants.POWER_SHARDS:
            laser_power += 1
            laser_power_shards = 0
