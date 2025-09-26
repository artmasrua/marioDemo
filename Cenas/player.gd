extends CharacterBody2D

class_name Player

@export_group("Locomotion")
@export var speed: float = 200.0
@export var jump_velocity: float = -350
@export var run_speed_damping: float = 0.5

@export_group("Stomping Enenmies")
@export var min_stomp_dregree = 35
@export var max_stomp_degre = 135
@export var stomp_y_velocity = -150

var is_dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	$AnimatedSprite2D._trigger_animation(velocity, direction)
	
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not (area is Enemy) or is_dead:
		return
		 
	if area is Koopa and (area as Koopa).in_a_shell:
		(area as Koopa)._on_stomp(global_position)
		return
	
	var angle = rad_to_deg(position.angle_to_point((area as Enemy).position))
	
	if angle > min_stomp_dregree and angle < max_stomp_degre:
		(area as Enemy)._die()
		velocity.y = stomp_y_velocity
	else:
		_die()
	
func _die():
	is_dead = true
	$AnimatedSprite2D.play("small_death")
	set_physics_process(false)
	set_collision_layer_value(1, false)
	set_collision_mask_value(3, false)
	
	var death_tween = get_tree().create_tween()
	death_tween.tween_property(self, "position", position + Vector2(0, -40), 0.5)
	death_tween.chain().tween_property(self, "position", position + Vector2(0, 240), 1)
	death_tween.tween_callback(func (): get_tree().reload_current_scene())
