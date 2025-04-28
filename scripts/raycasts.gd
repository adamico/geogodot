extends Node2D

@onready var raycasts: Dictionary = {
	Vector2.LEFT: [$LTRayCast, $LBRayCast],
	Vector2.RIGHT: [$RTRayCast, $RBRayCast],
	Vector2.UP: [$TLRayCast, $TRRayCast],
	Vector2.DOWN: [$BLRayCast, $BRRayCast],
}

@onready var player: Player = $"../../.."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction = player.direction
	if direction != Vector2.ZERO: get_collisions(direction)
	global_position = get_parent().global_position
	
	
func get_collisions(direction) -> Array:
	var collisions: Array
	
	for collider in raycasts[direction].map(raycast_collider):
		if collider:
			collisions.append(collider)
	
	return collisions


func raycast_collider(raycast: RayCast2D) -> CollisionObject2D:
	return raycast.get_collider()
