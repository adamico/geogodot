extends ParallaxBackground

@onready var space_layer: ParallaxLayer = %SpaceLayer


func _process(delta: float) -> void:
    space_layer.motion_offset.x += 20 * delta
