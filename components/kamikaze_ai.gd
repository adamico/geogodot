class_name KamikazeAIComponent
extends BasicAIComponent

const PLAYER_COLLISION_LAYER = 1

var overlapping_areas: Array[Area2D]

@onready var spawner_component: SpawnerComponent = %SpawnerComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var explosion_area: Area2D = %ExplosionArea
@onready var explosion_warning: Node2D = %"Explosion Warning"


func _ready() -> void:
    animation_player.animation_finished.connect(_on_animation_player_animation_finished)
    explosion_area.area_entered.connect(_on_explosion_area_entered)
    explosion_area.area_exited.connect(func(area): overlapping_areas.erase(area))
    super()

func _on_explosion_area_entered(area: Area2D) -> void:
    overlapping_areas.append(area)
    if area.collision_layer == PLAYER_COLLISION_LAYER:
        explosion_warning.show()
        animation_player.play("detonate")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
    overlapping_areas.map(func(overlapping_area): overlapping_area.hurt.emit(explosion_area))
    spawner_component.spawn()
    actor.call_deferred("queue_free")
    actor.dead.emit()
