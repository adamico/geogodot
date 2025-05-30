extends Node

signal last_enemy_in_wave_dead

const EXPLODER_ENEMY = preload("res://entities/enemy/exploder_enemy.tscn")
const HUNTER_ENEMY = preload("res://entities/enemy/hunter_enemy.tscn")
const SHOOTER_ENEMY = preload("res://entities/enemy/shooter_enemy.tscn")
const DASHER_ENEMY = preload("res://entities/enemy/dasher_enemy.tscn")

const ENEMY_TYPES_CONFIG := {
    "Hunter": { "scene": HUNTER_ENEMY, "base_weight": 3.0, "intro_wave": 0 }, # Introduce from wave 0 (or 1)
    "Dasher": { "scene": DASHER_ENEMY, "base_weight": 1.0, "intro_wave": 2 },
    "Shooter": { "scene": SHOOTER_ENEMY, "base_weight": 0.5, "intro_wave": 3 },
    "Exploder": { "scene": EXPLODER_ENEMY, "base_weight": 0.2, "intro_wave": 4 },
}

@export var mapping_context: GUIDEMappingContext

@export var base_wave_duration_seconds:= 120.0
@export var inter_wave_delay_seconds := 10.0  # Delay between waves
@export var number_of_waves:= 10
@export var base_enemies_per_wave:= 10


var game_start_time:= 0.0
var current_time:= 0.0
var elapsed_game_time:= 0.0
var waves: Array[Dictionary] = []
var number_of_introductory_waves:= 4
var current_wave:= 0
var enemies_spawned_this_wave:= 0
var enemies_remaining_this_wave: int
var rng = RandomNumberGenerator.new()

@onready var wave_timer: Timer = $WaveTimer
@onready var enemy_spawn_timer: Timer = $EnemyTimer
@onready var player: Player = %Player
@onready var p_1_start_position: Marker2D = %P1StartPosition
@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var camera_2d: Camera2D = %Camera2D
@onready var wave_number_label: Label = %WaveNumberLabel
@onready var wave_number_value: Label = %WaveNumberValue


func _ready() -> void:
    print("DEBUG: _ready() called. number_of_waves is: ", number_of_waves) # DEBUG

    GUIDE.enable_mapping_context(mapping_context)
    last_enemy_in_wave_dead.connect(_on_last_enemy_in_wave_dead)
    enemy_spawn_timer.timeout.connect(_on_enemy_spawner_timer_timeout)
    wave_timer.timeout.connect(_on_wave_timer_timeout)
    EventBus.actor_died.connect(_on_actor_died)

    _new_game()


func _process(_delta: float) -> void:
    current_time = Time.get_unix_time_from_system()
    elapsed_game_time = current_time - game_start_time
    # TODO: update UI for time_to_next_wave using wave_timer.time_left


func _new_game() -> void:
    print("DEBUG: _new_game() called.") # DEBUG

    _generate_waves_data()
    player.position = p_1_start_position.position
    game_start_time = Time.get_unix_time_from_system()
    current_wave = 0
    print("DEBUG: Initial wave_timer started for inter-wave delay. Current wave (internal): ", current_wave) # DEBUG


    wave_timer.start(inter_wave_delay_seconds)
    _update_wave_ui()


func _generate_waves_data() -> void:
    waves.clear()
    for n in range(number_of_waves):
        var wave_data = {}
        # Calculate enemies number: grows with each wave
        wave_data.enemies_number = base_enemies_per_wave + (base_enemies_per_wave * n / 2.0)
        wave_data.enemies_number = int(ceil(wave_data.enemies_number)) # Ensure whole numbers

        # Determine available enemy types for this wave
        wave_data.available_enemy_types = _get_available_enemy_types_for_wave(n)

        # Determine current enemy weights for this wave
        wave_data.current_weights = _calculate_enemy_weights_for_wave(n, wave_data.available_enemy_types)

        waves.append(wave_data)

    print("DEBUG: Generated waves data. Total waves generated: ", waves.size(), " (Expected: ", number_of_waves, ")") # DEBUG
    print("DEBUG: Waves array content: ", waves) # DEBUG


func _get_available_enemy_types_for_wave(wave_index: int) -> Array:
    var available_types = []
    for enemy_name in ENEMY_TYPES_CONFIG:
        var config = ENEMY_TYPES_CONFIG[enemy_name]
        if wave_index >= config.intro_wave:
            available_types.append(enemy_name)
    return available_types


func _calculate_enemy_weights_for_wave(wave_index: int, available_enemy_types: Array) -> Dictionary:
    var current_weights = {}
    if wave_index < number_of_introductory_waves:
        # Gradual introduction waves - custom weighting if needed, or simple default for introduced
        # For simplicity, let's make newly introduced enemies have high chance, others low
        for enemy_name in available_enemy_types:
            current_weights[enemy_name] = ENEMY_TYPES_CONFIG[enemy_name].base_weight # Use base weight for simplicity
            # You could add specific logic here, e.g., if wave_index == ENEMY_TYPES_CONFIG[enemy_name].intro_wave,
            # then make its weight very high for its introduction wave.
    else: # From Wave 4 (which is Wave 5 in game terms) onwards, use standard weights
        for enemy_name in available_enemy_types:
            current_weights[enemy_name] = ENEMY_TYPES_CONFIG[enemy_name].base_weight

    return current_weights


func _game_over() -> void:
    print("DEBUG: GAME OVER! Triggered at current_wave (internal): ", current_wave, " (Display: ", current_wave + 1, ")") # DEBUG

    enemy_spawn_timer.stop()
    wave_timer.stop()


func _new_wave() -> void:
    print("DEBUG: Entering _new_wave(). Current wave (internal) before increment: ", current_wave) # DEBUG

    current_wave += 1
    if current_wave >= number_of_waves:
        print("DEBUG: Current wave (", current_wave, ") is >= number_of_waves (", number_of_waves, "). Calling _game_over().") # DEBUG

        _game_over()
        return

    enemies_spawned_this_wave = 0
    enemies_remaining_this_wave = waves[current_wave].enemies_number

    # How often do enemies spawn? You can make this dynamic too.
    # For now, let's assume a fixed rate or based on total enemies
    var spawn_interval = base_wave_duration_seconds / float(enemies_remaining_this_wave)
    enemy_spawn_timer.start(spawn_interval)

    wave_timer.start(base_wave_duration_seconds)
    _update_wave_ui()
    print("DEBUG: Starting Wave ", current_wave + 1, " (internal: ", current_wave, ") with ", enemies_remaining_this_wave, " enemies.") # DEBUG


func _update_wave_ui() -> void:
    wave_number_value.text = str(current_wave + 1) # Display 1-indexed wave number
    # Update enemies left label if you have one linked to enemies_remaining_this_wave


func _on_actor_died(actor: Node2D) -> void:
    if actor is Player:
        _game_over()
    elif actor is Enemy:
        enemies_remaining_this_wave -= 1
        # Update UI here for enemies_left_container if needed
        if enemies_remaining_this_wave <= 0:
            last_enemy_in_wave_dead.emit()
        actor.died.emit()


func _on_enemy_spawner_timer_timeout() -> void:
    var wave_data = waves[current_wave]
    if enemies_spawned_this_wave >= wave_data.enemies_number:
        enemy_spawn_timer.stop() # All enemies for this wave have been spawned
        return

    rng.randomize() # Reseed RNG for truly random results

    var enemy_scene: PackedScene
    var available_enemy_types = wave_data.available_enemy_types
    var current_weights = wave_data.current_weights

    if available_enemy_types.is_empty():
        push_warning("No enemy types available for wave %d. Skipping spawn." % current_wave)
        return

    # Select enemy based on weighted random, or simple random for initial waves
    if current_wave < number_of_introductory_waves:
        # For gradual introduction, we can cycle through or pick randomly from available,
        # or bias towards the most recently introduced enemy.
        # Simple approach: Pick randomly from the *available* types for this wave
        var selected_enemy_name = available_enemy_types[rng.randi_range(0, available_enemy_types.size() - 1)]
        enemy_scene = ENEMY_TYPES_CONFIG[selected_enemy_name].scene
    else:
        # Build an array for weighted random selection
        var selection_array = []
        for enemy_name in available_enemy_types:
            for _i in range(int(current_weights[enemy_name] * 10)): # Multiply weight to get int copies
                selection_array.append(enemy_name)

        if selection_array.is_empty():
            push_warning("Selection array is empty for weighted spawn. Falling back to random from available.")
            var selected_enemy_name = available_enemy_types[rng.randi_range(0, available_enemy_types.size() - 1)]
            enemy_scene = ENEMY_TYPES_CONFIG[selected_enemy_name].scene
        else:
            var selected_enemy_name = selection_array[rng.randi_range(0, selection_array.size() - 1)]
            enemy_scene = ENEMY_TYPES_CONFIG[selected_enemy_name].scene

    var enemy: Node2D = enemy_scene.instantiate()

    path_follow_2d.progress_ratio = randf()
    enemy.global_position = path_follow_2d.global_position
    var spawn_offset_vector = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)).normalized() * 100
    enemy.global_position = path_follow_2d.global_position + spawn_offset_vector

    add_child(enemy)
    enemies_spawned_this_wave += 1

    if enemies_spawned_this_wave >= wave_data.enemies_number:
        enemy_spawn_timer.stop()


func _on_wave_timer_timeout() -> void:
    print("DEBUG: _on_wave_timer_timeout() called. Starting next wave via _new_wave().") # DEBUG

    _new_wave()


func _on_last_enemy_in_wave_dead() -> void:
    print("DEBUG: All enemies in Wave ", current_wave + 1, " defeated! (Internal: ", current_wave, ")") # DEBUG

    enemy_spawn_timer.stop() # Ensure no more enemies spawn if wave finished early
    if current_wave + 1 >= number_of_waves: # Check if this was the final wave
        print("DEBUG: All waves completed (current_wave + 1 = ", current_wave + 1, ", number_of_waves = ", number_of_waves, "). Calling _game_over().") # DEBUG

        _game_over() # All waves completed
        return

    # Start timer for delay until next wave
    wave_timer.start(inter_wave_delay_seconds)
    print("DEBUG: Next wave (", current_wave + 2, ", internal: ", current_wave + 1, ") starts in ", inter_wave_delay_seconds, " seconds. Wave timer started.") # DEBUG
