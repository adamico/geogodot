class_name HurtboxComponent
extends Area2D

@warning_ignore("unused_signal")
signal hurt(hitbox)

var is_invincible = false :
	set(value):
		is_invincible = value
		
		for child in get_children():
			if not child is CollisionShape2D and not child is CollisionPolygon2D: continue
			# Use call deferred to make sure this doesn't happen in the middle of the
			# physics process
			child.set_deferred("disabled", is_invincible)
