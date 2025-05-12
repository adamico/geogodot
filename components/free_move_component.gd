class_name FreeMoveComponent
extends Node

@export var actor: Node2D
@export var direction: Vector2
@export var speed:= 70

@onready var not_moving: AtomicState = %NotMoving
@onready var moving: AtomicState = %Moving
@onready var cannot_move: AtomicState = %CannotMove
@onready var state_chart: StateChart = %StateChart


func _ready() -> void:
    cannot_move.state_processing.connect(_on_cannot_move_state_processing)


func _process(delta: float) -> void:
    if direction == Vector2.ZERO:
        state_chart.send_event("stop_move")
    else:
        actor.translate(direction * speed * delta)
        state_chart.send_event("move")


func _on_cannot_move_state_processing(_delta: float) -> void:
    direction = Vector2.ZERO
