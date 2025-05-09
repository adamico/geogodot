class_name BaseAIComponent
extends Node2D

@export var state_chart: StateChart

var actor: Node2D
var astar_grid = AStarGrid2D.new()
var home_position: Vector2
var level: TileMapLayer
var path: Array[Vector2i]
var player: Player

@onready var calm: AtomicState = %Calm
@onready var alerted: AtomicState = %Alerted
@onready var angry: AtomicState = %Angry
@onready var not_moving: AtomicState = %NotMoving
@onready var moving: AtomicState = %Moving
@onready var stop_moving: AtomicState = %StopMoving


func _ready() -> void:
    actor = get_parent()
    setup_astar_grid.call_deferred()
    player = get_tree().get_first_node_in_group("players")

    calm.state_processing.connect(_on_calm_state_processing)
    alerted.state_processing.connect(_on_alerted_state_processing)
    angry.state_processing.connect(_on_angry_state_processing)
    not_moving.state_processing.connect(_on_not_moving_state_processing)


func _on_calm_state_processing(_delta: float) -> void:
    var from = level.local_to_map(actor.global_position)
    var random_position = Vector2i(randi_range(1, 3), randi_range(1, 3))
    var to = level.local_to_map(home_position) + random_position
    calculate_path(from, to)


func _on_alerted_state_processing(_delta: float) -> void:
    calculate_path(
            level.local_to_map(actor.global_position),
            level.local_to_map(player.global_position),
    )


func _on_angry_state_processing(_delta: float) -> void:
    calculate_path(
            level.local_to_map(actor.global_position),
            level.local_to_map(player.global_position),
    )


func _on_not_moving_state_processing(_delta: float) -> void:
    if path.is_empty():
        state_chart.send_event("no_path")
    else:
        state_chart.send_event("move")


func setup_astar_grid() -> void:
    astar_grid.region = level.get_used_rect()
    astar_grid.cell_size = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)
    astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
    astar_grid.update()


func calculate_path(from, to) -> Array[Vector2i]:
    var enemies = get_tree().get_nodes_in_group("enemies")
    var occupied_positions = []

    for enemy in enemies:
        if enemy == actor: continue
        occupied_positions.append(level.local_to_map(enemy.global_position))

    for occupied_position in occupied_positions:
        astar_grid.set_point_solid(occupied_position)

    path = astar_grid.get_id_path(from, to)
    path.pop_front()

    for occupied_position in occupied_positions:
        astar_grid.set_point_solid(occupied_position, false)

    return path
