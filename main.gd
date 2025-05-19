extends Node

signal last_enemy_in_wave_dead

const EXPLODER_ENEMY = preload("res://entities/enemy/exploder_enemy.tscn")
const HUNTER_ENEMY = preload("res://entities/enemy/hunter_enemy.tscn")

@export var mapping_context: GUIDEMappingContext
@export var base_wave_time:= 60.0

var game_start_time:= 0.0
var current_time:= 0.0
var elapsed_time:= 0.0
var waves: Array[Dictionary]
var current_wave:= 0
var enemies_spawned:= 0
var enemies_left: int
var enemy_max_weight: int
var number_of_waves:= 5
var time_to_next_wave:= 0.0
var rng = RandomNumberGenerator.new()

var enemy_scenes:= [HUNTER_ENEMY, EXPLODER_ENEMY]
var enemy_weights = PackedFloat32Array([2, 0.2])

@onready var wave_timer: Timer = $WaveTimer
@onready var enemy_timer: Timer = $EnemyTimer
@onready var player: Player = %Player
@onready var p_1_start_position: Marker2D = %P1StartPosition
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var camera_2d: Camera2D = %Camera2D
@onready var enemies_left_container: HBoxContainer = %EnemiesLeftContainer
@onready var wave_number_label: Label = %WaveNumberLabel
@onready var wave_number_value: Label = %WaveNumberValue


func _ready() -> void:
    GUIDE.enable_mapping_context(mapping_context)
    _new_game()


func _process(_delta: float) -> void:
    current_time = Time.get_unix_time_from_system()
    elapsed_time = current_time - game_start_time
    time_to_next_wave = wave_timer.time_left


func _new_game() -> void:
    _generate_waves()
    player.position = p_1_start_position.position
    game_start_time = Time.get_unix_time_from_system()
    wave_timer.start(10)


func _generate_waves() -> void:
    var base_number_of_enemies:= 10
    var number_of_enemies = base_number_of_enemies
    waves.resize(number_of_waves)
    for n in range(0, waves.size()):
        number_of_enemies += base_number_of_enemies * n / 2
        waves[n].enemies_number = number_of_enemies


func _game_over() -> void:
    enemy_timer.stop()


func _new_wave() -> void:
    if current_wave > number_of_waves: return
    enemies_spawned = 0
    enemy_timer.start()
    enemies_left = waves[current_wave].enemies_number
    wave_timer.start(base_wave_time)


func _on_player_dead() -> void:
    _game_over()


func _on_enemy_timer_timeout() -> void:
    if enemies_spawned >= waves[current_wave].enemies_number: return
    rng.randomize()

    var enemy_scene: PackedScene = enemy_scenes[rng.rand_weighted(enemy_weights)]
    var enemy: Node2D = enemy_scene.instantiate()
    path_follow_2d.progress_ratio = randf()

    enemy.position = path_follow_2d.position + camera_2d.get_screen_center_position()
    enemy.dead.connect(_on_enemy_death)
    add_child(enemy)
    enemies_spawned += 1


func _on_enemy_death() -> void:
    enemies_left -= 1
    if enemies_left == 0: last_enemy_in_wave_dead.emit()


func _on_wave_timer_timeout() -> void:
    current_wave += 1
    _new_wave()


func _on_last_enemy_in_wave_dead() -> void:
    wave_timer.start(10)
