extends Area2D

signal hit(hitter)
signal died(killer)

@onready var player: Player = $"../../.."
var number: int

func _ready() -> void:
	hit.connect(_on_hit)
	died.connect(_on_death)
	number = player.number
	
func _on_hit(hitter) -> void:
	player.hit.emit(hitter)
	
func _on_death(killer) -> void:
	player.died.emit(killer)
