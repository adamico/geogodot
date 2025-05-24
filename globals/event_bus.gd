extends Node

# Define your custom signals here for each type of event you want to broadcast.
# This makes event names discoverable, type-safe (if using typed signals),
# and helps avoid typos.

# --- GAME STATE EVENTS ---
signal game_started # Corrected: No () needed for no arguments
signal game_paused # Corrected
signal game_resumed # Corrected
signal game_over(reason: String)
signal game_restart_requested # Corrected

# --- PLAYER EVENTS ---
signal player_resource_changed(resource_name: String, new_value: int)

# --- ENEMY EVENTS ---
signal enemy_spawned(enemy_node: Node)

# --- COMMON EVENTS ---
signal actor_died(actor: Node2D)
signal actor_damaged(actor: Node2D, amount: int, current_health: int)
signal captured_tile(captured_cells: Array[PackedVector2Array], capture_faction: int)

# --- UI EVENTS (if UI components need to signal to other game parts) ---
signal button_pressed(button_name: String)
signal setting_changed(setting_key: String, new_value: Variant)

# --- ENVIRONMENTAL EVENTS ---
signal tile_corrupted(tile_coords: Vector2i) # When a tile becomes corrupted
signal area_effect_triggered(area_coords: Array[Vector2i], effect_type: String)

# --- Add more signals as your game grows! ---


func _ready():
    print("EventBus AutoLoad is ready.")
