class_name IsPlayerVisible
extends ConditionLeaf

@export var player_detection_range: float = 800.0
@export var vision_cone_angle: float = 180.0  # degrees
@export var forward_dir: Vector2
@export var angle_to_player: float

func tick(actor: Node, blackboard: Blackboard) -> int:
    var player: Node2D = get_tree().get_first_node_in_group("players")
    if not player: return FAILURE

    var direction_to_player = player.global_position - actor.global_position
    var distance = direction_to_player.length()
    if distance > player_detection_range: return FAILURE

    forward_dir = Vector2.RIGHT.rotated(actor.rotation)
    angle_to_player = forward_dir.angle_to(direction_to_player.normalized())
    if abs(angle_to_player) > deg_to_rad(vision_cone_angle): return FAILURE

    blackboard.set_value("player_position", player.global_position)
    blackboard.set_value("player_detected", true)
    return SUCCESS
