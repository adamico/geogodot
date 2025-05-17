class_name MoveToPatrolPoint
extends ActionLeaf

@export var patrol_points: Array[NodePath]
@export var speed:= 35.0
@export var point_reach_distance:= 1.0

var current_point_index: int = 0


func tick(actor: Node, blackboard: Blackboard) -> int:
    if patrol_points.is_empty(): return FAILURE

    var target_node: Node = get_node(patrol_points[current_point_index])
    if not target_node: return FAILURE

    var target_pos: Vector2 = target_node.global_position
    var direction: Vector2 = actor.global_position.direction_to(target_pos)

    actor.global_position += direction * speed * get_physics_process_delta_time()
    actor.rotation = lerp_angle(actor.rotation, atan2(direction.y, direction.x), 0.1)

    var distance = actor.global_position.distance_to(target_pos)
    if distance <= point_reach_distance:
        current_point_index = (current_point_index + 1) % patrol_points.size()
        blackboard.set_value("patrol_point_reached", true)
        return SUCCESS

    return RUNNING
