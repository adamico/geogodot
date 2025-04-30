extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var direction = $"../Shoot".direction

@export var shooter: Node2D

var speed: int = 150
var health: int = 1

signal died(killer)
signal hit(hitter)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.rotate(direction.angle())
	died.connect(_on_death)
	hit.connect(_on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += Vector2(speed*direction.x*delta,speed*direction.y*delta)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func _on_hit(hitter) -> void:
	health -= 1
	if health <= 0:
		died.emit(hitter)
		return
	
func _on_death(_killer) -> void:
	queue_free()
