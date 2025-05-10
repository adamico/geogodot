extends Marker2D

@export var enemy_scene: PackedScene
@export var max_spawned: int = 2
@export var level: TileMapLayer

var spawned: Array

@onready var state_chart: StateChart = %StateChart
@onready var enabled: AtomicState = %Enabled
@onready var disabled: AtomicState = %Disabled
@onready var cool_down: AtomicState = %CoolDown


func _ready() -> void:
    level = get_parent()
    cool_down.state_entered.connect(_on_cool_down_state_entered)


func _process(_delta: float) -> void:
    if spawned.size() >= max_spawned:
        state_chart.send_event("disable")
        return
    else:
        state_chart.send_event("enable")
        state_chart.send_event("spawn")


func _on_cool_down_state_entered() -> void:
    _spawn()


func _on_enemy_died(enemy: Node) -> void:
    var enemy_id = enemy.get_instance_id()
    spawned.erase(enemy_id)


func _spawn() -> void:
    var enemy: Node2D = enemy_scene.instantiate()
    var spawn_location = %SpawnLocation
    spawn_location.progress_ratio = randf()
    var spawn_position = spawn_location.position.snapped(Vector2.ONE * Constants.TILE_SIZE)
    enemy.dead.connect(_on_enemy_died.bind(enemy))
    enemy.level = level
    get_parent().add_child(enemy)
    enemy.position = spawn_position + global_position

    spawned.append(enemy.get_instance_id())
