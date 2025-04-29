extends Node2D

const GRID_SIZE = 32

@onready var sprite: Sprite2D = $Sprite2D
@onready var player_character: Node2D = $"../../../Player/Character"
@onready var level: TileMapLayer = $"../../Level"
@onready var collision_box: CollisionShape2D = $Sprite2D/Area2D/CollisionShape2D
@onready var state_chart: StateChart = $StateChart

var astar_grid: AStarGrid2D
var max_health: int = 3
var health: int = max_health
var speed: float = 60.0
var path: Array[Vector2i]

signal died
signal hit


func _ready() -> void:
	astar_grid = setup_astar_grid()
	var player = get_tree().get_first_node_in_group("players")
	player.capturing.connect(_on_player_capturing.bind(player))
	player.stop_capturing.connect(_on_player_stop_capturing.bind(player))
	died.connect(_on_death)
	hit.connect(_on_hit)


func _process(_delta: float) -> void:
	# if it has a target (player or random cell)
	state_chart.send_event("try_move")


### Custom functions
func setup_astar_grid() -> AStarGrid2D:
	var grid = AStarGrid2D.new()
	grid.region = level.get_used_rect()
	grid.cell_size = Vector2(GRID_SIZE, GRID_SIZE)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()

	return grid


func calculate_path(from, to) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var occupied_positions = []
	
	for enemy in enemies:
		if enemy == self: continue
		occupied_positions.append(level.local_to_map(enemy.global_position))
		
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position)
	
	path = astar_grid.get_id_path(from, to)
	path.pop_front()
	
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)


func _on_try_moving_state_processing(_delta: float) -> void:
	calculate_path(
		level.local_to_map(global_position),
		level.local_to_map(player_character.global_position),
		)
	
	if path.is_empty(): return
	
	var original_position = Vector2(global_position)
	
	global_position = level.map_to_local(path[0])
	sprite.global_position = original_position
	
	state_chart.send_event("move")


func _on_moving_state_processing(delta: float) -> void:
	if sprite.global_position == global_position:
		state_chart.send_event("stop_moving")
		return
	
	sprite.global_position = sprite.global_position.move_toward(
		global_position, speed*delta
	)


func _on_player_capturing(_player) -> void:
	state_chart.send_event("player_is_capturing")
	
	
func _on_player_stop_capturing(_player) -> void:
	state_chart.send_event("player_stops_capturing")


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().died.emit()
	hit.emit()


func _on_death() -> void:
	var explode_sound = $ExplodeSound
	explode_sound.play()
	collision_box.set_deferred("disabled", true)
	var tween = get_tree().create_tween()
	sprite.modulate = Color.BLACK
	tween.tween_property(sprite, "scale", Vector2(), 0.1)
	await get_tree().create_timer(explode_sound.stream.get_length()).timeout
	queue_free()


func _on_hit() -> void:
	health -= 1
	if health <= 0:
		died.emit()
		return
		
	$HitSound.play()
	
	sprite.modulate = Color.RED
	var tween = get_tree().create_tween()
	tween.tween_callback(sprite.set_modulate.bind(Color.WHITE)).set_delay(0.1)
	collision_box.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	collision_box.set_deferred("disabled", false)
