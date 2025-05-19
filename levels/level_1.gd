extends TileMapLayer

const LOOT = [null, null, null, null, null, null, "laser", "capture"]
const PICKUP:= preload("res://entities/items/Pickup.tscn")
const CAPTURABLE_ATLAS_COORDS = Vector2i(0, 0)
const HUNTER_ENEMY = preload("res://entities/enemy/hunter_enemy.tscn")

var max_loot: int
var loot_count:= {
    "laser": 0,
    "capture": 0
}

func _ready() -> void:
    var capturable_positions = get_used_cells_by_id(-1, CAPTURABLE_ATLAS_COORDS)
    max_loot = capturable_positions.size() / LOOT.size()
    capturable_positions.map(_add_loot)


func _add_loot(capturable_position) -> void:
    var pickup: Pickup = PICKUP.instantiate()
    var label_text = LOOT.pick_random()
    if not label_text: return
    if loot_count[label_text] > max_loot: return
    pickup.label_text = label_text
    add_child(pickup)
    pickup.global_position = map_to_local(capturable_position)
    loot_count[pickup.label_text] += 1
