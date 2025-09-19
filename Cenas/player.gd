extends CharacterBody2D

class_name Player

@export_group("Locomotion")
@export var speed = 200.0
@export var jump_velocity = -350
@export var run_speed_damping = 0.5

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
	if area is Enemy:
		(area as Enemy)._die_from_hit_hit()
