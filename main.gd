extends Node

@export var enemy_scene: PackedScene
@export var mapping_context: GUIDEMappingContext

var spawned_enemies: int = 0
var max_enemies:= 10
var game_start_time:= 0.0
var current_time:= 0.0
var elapsed_time:= 0.0

@onready var start_timer: Timer = $StartTimer
@onready var enemy_timer: Timer = $EnemyTimer
@onready var player: Player = $Player
@onready var p_1_start_position: Marker2D = $P1StartPosition
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var camera_2d: Camera2D = %Camera2D


func _ready() -> void:
    GUIDE.enable_mapping_context(mapping_context)
    _new_game()


func _process(_delta: float) -> void:
    current_time = Time.get_unix_time_from_system()
    elapsed_time = current_time - game_start_time

func _new_game() -> void:
    player.position = p_1_start_position.position
    start_timer.start()
    game_start_time = Time.get_unix_time_from_system()


func _on_player_dead() -> void:
    enemy_timer.stop()


func _on_start_timer_timeout() -> void:
    enemy_timer.start()


func _on_enemy_timer_timeout() -> void:
    if spawned_enemies > max_enemies: return
    var enemy: Node2D = enemy_scene.instantiate()
    path_follow_2d.progress_ratio = randf()

    enemy.position = path_follow_2d.position + camera_2d.get_screen_center_position()
    enemy.dead.connect(_on_enemy_death)
    add_child(enemy)
    spawned_enemies += 1


func _on_enemy_death() -> void:
    spawned_enemies -= 1
