extends Area2D

class_name Enemy

@export var h_speed: float = 20.0
@export var v_speed: float = 100.0
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	position.x -= h_speed * delta
	
	if !ray_cast_2d.is_colliding():
		position.y += v_speed * delta

func _die(): #morte pelo mario
	h_speed = 0
	v_speed = 0
	animated_sprite_2d.play("dead")

func _die_from_hit(): #morte pelo casco
	h_speed = 0
	v_speed = 0
	rotation_degrees = 180
	
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	
	var dead_tween = get_tree().create_tween()
	dead_tween.tween_property(self, "position", position + Vector2(0, -25), 0.4)
	dead_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 4)
