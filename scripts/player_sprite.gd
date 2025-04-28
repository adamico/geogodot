extends AnimatedSprite2D

signal died
@onready var player: Player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	died.connect(_on_death)
	
func _on_death() -> void:
	player.died.emit()
