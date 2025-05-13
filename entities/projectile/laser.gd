extends Node2D

@export var direction: Vector2

@onready var move_component: MoveComponent = %MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var hitbox_component: HitboxComponent = %HitboxComponent

func _ready() -> void:
    move_component.direction = direction


func _on_hitbox_component_hit_hurtbox(hurtbox: Variant) -> void:
    if hurtbox is not HurtboxComponent: return
    queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
