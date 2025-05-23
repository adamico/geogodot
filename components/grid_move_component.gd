class_name GridMoveComponent
extends Node

@export var actor: Node2D
@export var sprite: AnimatedSprite2D
@export var state_chart: StateChart
@export var speed: float

var moving_direction: Vector2 = Vector2.ZERO
var ray_cast_2d: RayCast2D

@onready var not_moving: AtomicState = %NotMoving
@onready var moving: AtomicState = %Moving
@onready var cannot_move: AtomicState = %CannotMove


func _ready() -> void:
    ray_cast_2d = actor.get_node("RayCast2D")
    ray_cast_2d.target_position = Vector2.DOWN * Constants.TILE_SIZE
    not_moving.state_processing.connect(_on_not_moving_state_processing)
    moving.state_exited.connect(_on_moving_state_exited)

    cannot_move.state_processing.connect(_on_cannot_move_state_processing)
    cannot_move.state_exited.connect(_on_cannot_move_state_exited)


func _on_not_moving_state_processing(_delta: float) -> void:
    if moving_direction.length() > 0:
        state_chart.send_event("move")


func _on_moving_state_exited() -> void:
    sprite.play("idle")


func _on_cannot_move_state_processing(_delta: float) -> void:
    moving_direction = Vector2.ONE


func _on_cannot_move_state_exited() -> void:
    moving_direction = Vector2.ZERO


func move(direction: Vector2) -> void:
    if moving_direction.length() == 0 && direction.length() > 0:
        var movement = Vector2.DOWN
        if direction.y > 0: movement = Vector2.DOWN
        elif direction.y < 0: movement = Vector2.UP
        elif direction.x > 0: movement = Vector2.RIGHT
        elif direction.x < 0: movement = Vector2.LEFT

        ray_cast_2d.target_position = movement * Constants.TILE_SIZE
        ray_cast_2d.force_raycast_update()

        if !ray_cast_2d.is_colliding():
            moving_direction = movement

            var new_position = actor.global_position + (moving_direction * Constants.TILE_SIZE)
            var tween = create_tween()
            tween.tween_property(
                    actor, "position",
                    new_position,
                    speed
            ).set_trans(Tween.TRANS_LINEAR)
            _play_moving_animation(moving_direction)
            tween.tween_callback(func():
                    moving_direction = Vector2.ZERO
                    state_chart.send_event("stop_move")
            )


func _play_moving_animation(direction: Vector2) -> void:
    var directions_to_sprites: Dictionary = {
        Vector2.LEFT: "move_left",
        Vector2.RIGHT: "move_right",
        Vector2.UP: "move_up",
        Vector2.DOWN: "move_down",
        Vector2.ZERO: "idle"
    }

    var diagonals = [
        Vector2(1, 1), Vector2(-1, 1),
        Vector2(1, -1), Vector2(-1, -1)
    ]
    if diagonals.find(direction) != -1: return
    sprite.play(directions_to_sprites[direction])
