extends Marker2D


@onready var state_chart: StateChart = $StateChart
@export var enemy_scene: PackedScene

signal enemy_died

var spawned: Array
var max_spawned: int = 4

func _process(delta: float) -> void:
	if spawned.size() >= max_spawned:
		state_chart.send_event("disable")
		return
	else:
		state_chart.send_event("enable")
	
	state_chart.send_event("spawn")

func spawn() -> void:
	var enemy: Node2D = enemy_scene.instantiate()
	
	# Choose a random location on Path2D.
	var enemy_spawn_location = $SpawnPath/SpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	
	enemy.died.connect(_on_enemy_died.bind(enemy))
	add_child(enemy)
	spawned.append(enemy.get_instance_id())


func _on_cool_down_state_entered() -> void:
	spawn()
	
	
func _on_enemy_died(enemy: Node) -> void:
	var enemy_id = enemy.get_instance_id()
	spawned.erase(enemy_id)
