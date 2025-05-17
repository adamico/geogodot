class_name ChasePlayer
extends ActionLeaf

@export var speed:= 70.0
@export var attack_range:= 30.0


func tick(actor: Node, blackboard: Blackboard) -> int:
    var player_pos = blackboard.get_value("player_position")
    if not player_pos: return FAILURE

    var direction: Vector2 = actor.global_position.direction_to(player_pos)
    actor.global_position += direction * speed * get_physics_process_delta_time()
    blackboard.set_value("attack_range", attack_range)
    var distance: float = actor.global_position.distance_to(player_pos)
    if distance <= attack_range: return SUCCESS

    return RUNNING
