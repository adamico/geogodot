class_name StatsComponent
extends Node

signal health_changed
signal no_health

@export var health: int = 1:
	set(value):
		health = value
		
		health_changed.emit()
		
		if health == 0: no_health.emit()
