extends TileMapLayer

const LOOT = [null, null, null, null, null, null, "laser", "capture"]
const PICKUP:= preload("res://entities/items/Pickup.tscn")
const CAPTURABLE_ATLAS_COORDS = Vector2i(0, 0)

var captured_cells: Array
var max_loot: int
var loot_count:= {
    "laser": 0,
    "capture": 0
}


func _ready() -> void:
    var capturable_positions = get_used_cells_by_id(-1, CAPTURABLE_ATLAS_COORDS)
    @warning_ignore("integer_division")
    max_loot = capturable_positions.size() / LOOT.size()
    capturable_positions.map(_add_loot)
    captured_cells = [[], [], []]
    EventBus.captured_tile.connect(_on_captured_tile)


func _add_loot(capturable_position) -> void:
    var pickup: Pickup = PICKUP.instantiate()
    var label_text = LOOT.pick_random()
    if not label_text: return
    if loot_count[label_text] > max_loot: return
    pickup.label_text = label_text
    add_child(pickup)
    pickup.global_position = map_to_local(capturable_position)
    loot_count[pickup.label_text] += 1


func _set_captured(cell, capture_faction) -> void:
    set_cell(cell, 0, Vector2i(capture_faction, 0))
    captured_cells.append(cell)


func _reveal_pickup_at(cell) -> void:
    var found_pickup: Pickup = _pickup_at(cell)
    if not found_pickup: return
    found_pickup._show_and_enable()


func _pickup_at(cell) -> Node:
    var pickups: Array[Node] = get_tree().get_nodes_in_group("pickups")
    var found_pickup: Node

    for pickup: Pickup in pickups:
        if local_to_map(pickup.global_position) == cell: found_pickup = pickup

    return found_pickup


func _on_captured_tile(cells, capture_faction) -> void:
    for cell in cells:
        _set_captured(cell, capture_faction)
        _reveal_pickup_at(cell)
