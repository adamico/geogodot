class_name KiterAiComponent
extends BasicAIComponent

@export var shooting_distance: float = 200
@export var fleeing_distance: float = 150

var base_speed: float

@onready var state_chart: StateChart = %StateChart
@onready var approach: AtomicState = %Approach
@onready var shoot: AtomicState = %Shoot
@onready var flee: AtomicState = %Flee
@onready var shoot_component: ShootComponent = %ShootComponent
@onready var target_component: TargetComponent = %TargetComponent
@onready var rig: Node2D = %Rig


func _ready() -> void:
    base_speed = speed
    approach.state_processing.connect(_on_approach_state_processing)
    shoot.state_processing.connect(_on_shoot_state_processing)
    flee.state_processing.connect(_on_flee_state_processing)

    super()


func _physics_process(_delta: float) -> void:
    if not player: return
    if not actor: return
    var target_direction: Vector2 = rig.global_position.direction_to(player.global_position)
    target_component.direction = target_direction


func _try_approach() -> bool:
    if actor.global_position.distance_to(player.global_position) <= shooting_distance:
        return false
    state_chart.send_event("prevent_shoot")
    state_chart.send_event("approach")
    return true


func _try_shoot() -> bool:
    if actor.global_position.distance_to(player.global_position) > shooting_distance or\
            actor.global_position.distance_to(player.global_position) <= fleeing_distance:
        return false
    state_chart.send_event("allow_shoot")
    state_chart.send_event("shoot")
    return true


func _try_flee() -> bool:
    if actor.global_position.distance_to(player.global_position) > fleeing_distance:
        return false
    state_chart.send_event("prevent_shoot")
    state_chart.send_event("flee")
    return true


func _on_approach_state_processing(_delta: float) -> void:
    if not player: return
    if _try_shoot():
        return
    if _try_flee():
        return
    speed = base_speed
    direction = actor.global_position.direction_to(player.global_position)
    actor.velocity = direction * speed
    actor.move_and_slide()


func _on_shoot_state_processing(_delta: float) -> void:
    if not player: return
    if _try_approach():
        return
    if _try_flee():
        return
    speed = 0
    shoot_component.fire_projectile()


func _on_flee_state_processing(_delta: float) -> void:
    if not player: return
    if _try_approach():
        return
    if _try_shoot():
        return
    state_chart.send_event("prevent_shoot")
    speed = base_speed
    direction = -actor.global_position.direction_to(player.global_position)
    actor.velocity = direction * speed
    actor.move_and_slide()
