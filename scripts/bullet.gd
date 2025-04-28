extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var direction = $"../Shoot".direction

var speed: int = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sound.play()
	sprite.rotate(direction.angle())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += Vector2(speed*direction.x*delta,speed*direction.y*delta)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
