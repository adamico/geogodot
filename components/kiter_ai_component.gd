class_name KiterAiComponent
extends BasicAIComponent

@export var shooting_reach: float = 150

var base_speed: float

@onready var state_chart: StateChart = %StateChart
@onready var chase: AtomicState = %Chase
@onready var shoot: AtomicState = %Shoot
@onready var shoot_component: ShootComponent = %ShootComponent
@onready var target_component: TargetComponent = %TargetComponent
@onready var rig: Node2D = %Rig


func _ready() -> void:
    base_speed = speed
    chase.state_processing.connect(_on_chase_state_processing)
    shoot.state_processing.connect(_on_shoot_state_processing)
    super()


func _physics_process(_delta: float) -> void:
    if not player: return
    if not actor: return
    var target_direction: Vector2 = rig.global_position.direction_to(player.global_position)
    target_component.direction = target_direction


func _on_chase_state_processing(_delta: float) -> void:
    if not player: return
    if actor.global_position.distance_to(player.global_position) <= shooting_reach:
        state_chart.send_event("shoot")
        return
    shoot_component.stop_firing()
    speed = base_speed
    direction = actor.global_position.direction_to(player.global_position)
    actor.velocity = direction * speed
    actor.move_and_slide()


func _on_shoot_state_processing(_delta: float) -> void:
    if not player: return
    if actor.global_position.distance_to(player.global_position) > shooting_reach:
        state_chart.send_event("chase")
        return
    speed = 0
    shoot_component.fire_projectile()
