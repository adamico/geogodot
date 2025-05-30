extends TextureProgressBar

@onready var triangle_form: Node2D = %TriangleForm


func _ready() -> void:
    hide_cooldown()


func start_cooldown(duration: float) -> void:
    max_value = duration
    value = 0.0
    show()



func update_cooldown_indicator(elapsed_time: float) -> void:
    value = elapsed_time


func hide_cooldown() -> void:
    hide()
    triangle_form.modulate = Color.WHITE
