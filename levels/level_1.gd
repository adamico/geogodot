extends TileMapLayer

const SPAWNER = preload("res://entities/spawner/spawner.tscn")
const SPAWNER_TILE_COORDS = Vector2i(10, 6)


func _ready() -> void:
    var spawner_positions = get_used_cells_by_id(-1, SPAWNER_TILE_COORDS)
    spawner_positions.map(_add_spawner)


func _add_spawner(spawner_position) -> void:
    var spawner = SPAWNER.instantiate()
    add_child(spawner)
    spawner.global_position = map_to_local(spawner_position)
