class_name AttackPlayer
extends ActionLeaf

@export var attack_cooldown:= randf() + 0.2

var time_since_last_attack:= 0.0


func tick(actor: Node, blackboard: Blackboard) -> int:
    if time_since_last_attack < attack_cooldown:
        time_since_last_attack += get_physics_process_delta_time()
        return RUNNING

    time_since_last_attack = 0.0

    print("Enemy attacks player!")

    return SUCCESS
