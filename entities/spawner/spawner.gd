extends Marker2D

@export var enemy_scene: PackedScene
@export var max_spawned: int = 2
@export var level: TileMapLayer

var spawned: Array
@onready var state_chart: StateChart = $StateChart


func _ready() -> void:
    level = get_parent()


func _process(_delta: float) -> void:
    if spawned.size() >= max_spawned:
        state_chart.send_event("disable")
        return
    else:
        state_chart.send_event("enable")

    state_chart.send_event("spawn")


func _on_cool_down_state_entered() -> void:
    spawn()


func _on_enemy_died(enemy: Node) -> void:
    var enemy_id = enemy.get_instance_id()
    spawned.erase(enemy_id)


func spawn() -> void:
    var enemy: Node2D = enemy_scene.instantiate()

    # Choose a random location on Path2D.
    var enemy_spawn_location = $SpawnPath / SpawnLocation
    enemy_spawn_location.progress_ratio = randf()
    enemy.position = enemy_spawn_location.position
    enemy.dead.connect(_on_enemy_died.bind(enemy))
    enemy.level = level
    add_child(enemy)
    enemy.base_ai_component.home_position = enemy.global_position
    spawned.append(enemy.get_instance_id())
