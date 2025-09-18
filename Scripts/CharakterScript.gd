extends CharacterBody2D

@export var player_data: PlayerData
@onready var gun: Node2D = $Gun
@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var hurtbox: Area2D = $Hurtbox

@export_enum("Idle", "Run", "Dash") var char_state: String = "Idle"


func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Normalize and apply speed
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * player_data.speed
	else:
		velocity = Vector2.ZERO
	
	# Update last direction if moving
	if input_vector != Vector2.ZERO and not player_data.is_dashing:
		player_data.last_direction = input_vector.normalized()

	if player_data.is_dashing:
		velocity = player_data.last_direction * player_data.dashSpeed
	else:
		velocity = input_vector * player_data.speed
	if Input.is_action_just_pressed("Dash"):
		start_dash()
	move_and_slide()

	# Flip sprite if moving left/right
	### Später zur rotation der Waffe ändern
	if velocity.x != 0:
		player_anim.flip_h = velocity.x < 0
	
func start_dash() -> void:
	player_data.is_dashing = true
	velocity = player_data.last_direction * player_data.dashSpeed

	# Play dash animation
	player_anim.play("Dash")

	# Disable hurtbox detection and gun during dash
	hurtbox.monitoring = false
	hurtbox.monitorable = false
													###########Add that the gun and the script get disabled and reenabled when dashing
	#gun.process_mode = Node.PROCESS_MODE_DISABLED

	# Start the timer for the dash
	timer.start()

func end_dash() -> void:
	player_data.is_dashing = false

	# Re-enable hurtbox and gun
	hurtbox.monitoring = true
	hurtbox.monitorable = true
													###########Add that the gun and the script get disabled and reenabled when dashing
	#gun.process_mode = Node.PROCESS_MODE_INHERIT

	# Switch back to walk or idle depending on input
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir == Vector2.ZERO:
		player_anim.play("Idle")
	else:
		player_anim.play("Run")

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


func _on_timer_timeout() -> void:
	end_dash()
