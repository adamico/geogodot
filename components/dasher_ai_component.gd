class_name DasherAIComponent
extends Node2D

@export var actor: CharacterBody2D
@export var speed: float = 50.0
@export var shooting_distance: float = 200
@export var fleeing_distance: float = 150

var base_speed: float
var player: Player
var direction: Vector2

@onready var state_chart: StateChart = %StateChart
@onready var walk: AtomicState = %Walk
@onready var dash: AtomicState = %Dash
@onready var rig: Node2D = %Rig


func _ready() -> void:
    player = get_tree().get_first_node_in_group("players")
    base_speed = speed


func _physics_process(_delta: float) -> void:
    if not player: return
    if not actor: return
    direction = actor.global_position.direction_to(player.global_position)
    actor.velocity = direction * speed
    actor.move_and_slide()


func _on_walk_state_processing(_delta) -> void:
    pass
