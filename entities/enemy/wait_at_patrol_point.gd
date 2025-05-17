class_name WaitAtPatrolPoint
extends ActionLeaf

@export var wait_time:= 2.0

var current_wait_time:= 0.0


func tick(actor: Node, blackboard: Blackboard) -> int:
    if blackboard.get_value("patrol_point_reached"):
        blackboard.set_value("patrol_point_reached", false)
        current_wait_time = 0.0

    current_wait_time += get_physics_process_delta_time()

    if current_wait_time >= wait_time: return SUCCESS

    return RUNNING
