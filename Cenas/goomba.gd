extends Enemy

class_name Goomba

func _die():
	super.die()
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	get_tree().create_timer(0.5).timeout.connect(queue_free)

func _on_area_entered(area: Area2D) -> void:
	if area is Koopa && (area as Koopa).in_a_shell && (area as Koopa).h_speed != 0:
		_die_from_hit_hit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
