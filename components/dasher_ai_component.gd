class_name DasherAIComponent
extends Node2D

@export var actor: CharacterBody2D
@export var dashing_speed: float = 500.0
@export var walking_speed: float = 40.0
@export var dashing_distance: float = 200

var speed: float
var player: Player
var direction: Vector2

@onready var state_chart: StateChart = %StateChart
@onready var walk: AtomicState = %Walk
@onready var wind_up: AtomicState = %WindUp
@onready var dash: AtomicState = %Dash
@onready var dash_warning_line: Line2D = %DashWarningLine
@onready var rig: Node2D = %Rig
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer


func _ready() -> void:
    player = get_tree().get_first_node_in_group("players")
    walk.state_processing.connect(_on_walk_state_processing)
    dash.state_processing.connect(_on_dash_state_processing)
    dash.state_entered.connect(_on_dash_state_entered)
    dash.state_exited.connect(_on_dash_state_exited)
    wind_up.state_entered.connect(_on_wind_up_state_entered)
    wind_up.state_processing.connect(_on_wind_up_state_processing)


func _physics_process(_delta: float) -> void:
    actor.move_and_slide()


func _can_wind_up() -> bool:
    return actor.global_position.distance_to(player.global_position) <= dashing_distance\
            and dash_cooldown_timer.is_stopped()


func _on_walk_state_processing(_delta) -> void:
    if not player:
        actor.velocity = Vector2.ZERO
    else:
        rig.look_at(player.global_position)
        direction = actor.global_position.direction_to(player.global_position)
        speed = walking_speed
        actor.velocity = direction * speed
        if _can_wind_up():
            state_chart.send_event("wind_up")


func _on_wind_up_state_entered() -> void:
    direction = actor.global_position.direction_to(player.global_position)
    dash_warning_line.look_at(player.global_position)
    dash_warning_line.show()
    actor.velocity = Vector2.ZERO
    dash_cooldown_timer.start()


func _on_wind_up_state_processing(_delta) -> void:
    if dash_cooldown_timer.is_stopped():
        state_chart.send_event("dash")


func _on_dash_state_entered() -> void:
    if not player:
        state_chart.send_event("walk")
    else:
        speed = dashing_speed
        actor.velocity = direction * speed

func _on_dash_state_processing(delta) -> void:
    dash_warning_line.hide()
    actor.velocity = actor.velocity.lerp(Vector2.ZERO, 1 - exp(-3 * delta))
    if actor.velocity.length() < 1:
        state_chart.send_event("walk")


func _on_dash_state_exited() -> void:
    dash_cooldown_timer.start()
