class_name Player
extends CharacterBody2D


const SIZE = preload("res://entities/player/size.tscn")
const CURSOR = preload("res://assets/sprites/tile_0055.png")

@export var level: TileMapLayer
@export var capture_action: GUIDEAction
@export var move_action: GUIDEAction
@export var shoot_action: GUIDEAction
@export var target_action: GUIDEAction

@export var relative_to_player: RelativeToPlayerModifier
@export var max_health:= 3

var input_direction: Vector2
var capture_faction: int
var rig_global_position: Vector2


@onready var capture_component: CaptureComponent = %CaptureComponent
@onready var free_move_component: FreeMoveComponent = %FreeMoveComponent
@onready var shoot_component: ShootComponent = %ShootComponent
@onready var stats_component: StatsComponent = %StatsComponent
@onready var target_component: TargetComponent = %TargetComponent
@onready var power_up_component: PowerUpComponent = %PowerUpComponent
@onready var rig: Node2D = $Rig


func _ready() -> void:
    add_to_group("players")
    capture_faction = Constants.CaptureFactions.PLAYERS
    position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
    position -= Vector2.ONE * (Constants.TILE_SIZE / 2.0)

    stats_component.health = max_health

    capture_component.level = level
    capture_action.completed.connect(capture_component.try_capture)

    shoot_action.triggered.connect(shoot_component.fire_projectile)
    shoot_action.completed.connect(shoot_component.stop_firing)

    for power: String in ["size", "capture", "laser"]: _setup_initial_power_stats(power)
    power_up_component.size_up.connect(_on_power_up_component_size_up)

    Input.set_custom_mouse_cursor(CURSOR, Input.CursorShape.CURSOR_ARROW, Vector2(8,8))


func _process(_delta: float) -> void:
    rig_global_position = rig.global_position
    input_direction = move_action.value_axis_2d
    free_move_component.direction = input_direction

    relative_to_player.player_coordinates = rig.global_position
    var target_direction = target_action.value_axis_2d
    if target_direction: target_component.direction = target_direction


func _setup_initial_power_stats(power: String) -> void:
    var power_value: int = stats_component.get(power + "_power")
    for i: int in range(power_value + 1):
        stats_component.call("@" + power + "_power_setter", i)


func _on_power_up_component_size_up() -> void:
    var size_scene = SIZE.instantiate()
    var starting_positions: Array[Vector2] = [
        Vector2.ZERO,
        Vector2.RIGHT,
        Vector2.LEFT,
        Vector2.UP,
        Vector2.DOWN
    ]
    var size_power = stats_component.size_power
    size_scene.position = starting_positions[size_power] * Constants.TILE_SIZE
    rig.add_child(size_scene)
