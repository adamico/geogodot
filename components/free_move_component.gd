class_name FreeMoveComponent
extends Node

@export var actor: CharacterBody2D
@export var direction: Vector2
@export var speed:= 10
@export var max_speed:= 100
@export var acceleration:= 4
@export var friction:= 8

@onready var not_moving: AtomicState = %NotMoving
@onready var moving: AtomicState = %Moving
@onready var cannot_move: AtomicState = %CannotMove
@onready var state_chart: StateChart = %StateChart
@onready var moving_sound: AudioStreamPlayer = %MovingSound
@onready var stop_moving_sound: AudioStreamPlayer = %StopMovingSound
@onready var hitbox_component: HitboxComponent = %HitboxComponent


func _physics_process(_delta: float) -> void:
    if direction == Vector2.ZERO:
        state_chart.send_event("stop_move")
        _decelerate()
    else:
        _accelerate()
        state_chart.send_event("move")

    actor.move_and_slide()


func _accelerate() -> void:
    actor.velocity = actor.velocity.move_toward(direction * max_speed, acceleration)


func _decelerate() -> void:
    actor.velocity = actor.velocity.move_toward(Vector2.ZERO, friction)


func _play_moving_animation() -> void:
    var directions_to_sprites: Dictionary = {
        Vector2.LEFT: "move_left",
        Vector2.RIGHT: "move_right",
        Vector2.UP: "move_up",
        Vector2.DOWN: "move_down",
        Vector2.ZERO: "idle",
        Vector2(1, 1): "move_down_right",
        Vector2(-1, 1): "move_down_left",
        Vector2(1, -1): "move_up_right",
        Vector2(-1, -1): "move_up_left"
    }


func _on_cannot_move_state_processing(_delta: float) -> void:
    direction = Vector2.ZERO


func _on_moving_state_processing(_delta: float) -> void:
    if not moving_sound.playing: moving_sound.play()


func _on_moving_state_exited() -> void:
    moving_sound.stop()
    stop_moving_sound.play()
