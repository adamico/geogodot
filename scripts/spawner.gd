extends Marker2D


@export var enemy_scene: PackedScene
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.start()

var spawned: int = 0

func spawn() -> void:
	var enemy = enemy_scene.instantiate()
	
	# Choose a random location on Path2D.
	var enemy_spawn_location = $SpawnPath/SpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	add_child(enemy)
	
	spawned += 1

func _on_spawn_timer_timeout() -> void:
	if spawned < 3: spawn()
