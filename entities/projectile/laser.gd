extends Node2D

@export var direction: Vector2

@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
    move_component.direction = direction

    visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
    hitbox_component.hit_hurtbox.connect(_on_hit)


func _on_hit(hurtbox) -> void:
    queue_free()


func _on_screen_exited() -> void:
    queue_free()
