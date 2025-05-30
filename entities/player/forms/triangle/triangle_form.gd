extends Node2D

@export var stats_component: StatsComponent

var form_stages: Dictionary
var all_triangles: Array[Node]

@onready var triangle_0: Node2D = %Triangle0
@onready var triangle_1: Node2D = %Triangle1
@onready var triangle_1_1: Node2D = %"Triangle1-1"
@onready var triangle_1_2: Node2D = %"Triangle1-2"
@onready var triangle_1_3: Node2D = %"Triangle1-3"
@onready var triangle_2: Node2D = %Triangle2
@onready var triangle_2_1: Node2D = %"Triangle2-1"
@onready var triangle_2_2: Node2D = %"Triangle2-2"
@onready var triangle_2_3: Node2D = %"Triangle2-3"
@onready var triangle_3: Node2D = %Triangle3
@onready var triangle_3_1: Node2D = %"Triangle3-1"
@onready var triangle_3_2: Node2D = %"Triangle3-2"
@onready var triangle_3_3: Node2D = %"Triangle3-3"
@onready var multi_flash_component: MultiFlashComponent = %MultiFlashComponent


func _ready() -> void:
    stats_component.health_changed.connect(_on_actor_health_changed)
    form_stages = {
        "low": [ triangle_0, triangle_1, triangle_2, triangle_3 ],
        "mid": [ triangle_1, triangle_2, triangle_3 ],
        "full": [
            triangle_1_1, triangle_1_2, triangle_1_3,
            triangle_2_1, triangle_2_2, triangle_2_3,
            triangle_3_1, triangle_3_2, triangle_3_3,
        ],
    }
    all_triangles = get_children()
    _change_form("full")


func _on_actor_health_changed(actor: Node2D, current_health: int) -> void:
    if actor is not Player:
        return
    if current_health <= 0:
        return
    var form_key: String
    if current_health >= actor.max_health / 3:
        form_key = "low"
    if current_health >= actor.max_health / 3 * 2:
        form_key = "mid"
    if current_health == actor.max_health:
        form_key = "full"

    _change_form(form_key)


func _change_form(form_key) -> void:
    for triangle in all_triangles:
        triangle.hide()

    for triangle in form_stages[form_key]:
        triangle.show()
