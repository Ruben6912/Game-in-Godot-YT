extends "res://Scripts/Entity.gd"
class_name Player

@onready var gun: Node2D = $Gun
@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	# Input
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	
	# Normalize and apply speed
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * speed
	else:
		velocity = Vector2.ZERO
	
	# Move with collision
	move_and_slide()
	
	# Flip sprite if moving left/right
	if velocity.x != 0:
		player_anim.flip_h = velocity.x < 0
	
	# Play correct animation
	if velocity.length() > 0:
		_play_walk_animation()
	else:
		_play_idle_animation()
	print(velocity)

func _play_walk_animation() -> void:
	if player_anim.animation != "Run":
		player_anim.play("Run")

func _play_idle_animation() -> void:
	if player_anim.animation != "Idle":
		player_anim.play("Idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot_1"):
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - gun.muzzle.global_position).normalized()
		gun.fire(dir)
