extends Area2D

@onready var bullet: Node2D = $".."

var number: int

signal hit(hitter)

func _ready() -> void:
	hit.connect(_on_hit)
	number = bullet.shooter.number

func get_killer() -> Node2D:
	return bullet.shooter
	
func _on_hit(hitter) -> void:
	bullet.hit.emit(hitter) 
