extends CharacterBody2D


@onready var pause_menu: Control   # pause menu
func pause():
	if resource_data.can_pause == true:
		get_tree().paused = true
		resource_data.can_pause = false
		var message = "can't pause at the moment."
		print(message)
func unpause():
		get_tree().paused = false
		resource_data.can_pause = true
@export var resource_data: PlayerData
@onready var gun: Node2D = $Gun
@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var hurtbox: Area2D = $Hurtbox

@export_enum("Idle", "Run", "Dash") var char_state: String = "Idle"

func _physics_process(delta: float) -> void:
	gun.look_at(get_global_mouse_position())
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Normalize and apply speed
	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * resource_data.speed
	else:
		velocity = Vector2.ZERO
	
	# Update last direction if moving
	if input_vector != Vector2.ZERO and not resource_data.is_dashing:
		resource_data.last_direction = input_vector.normalized()

	if resource_data.is_dashing:
		velocity = resource_data.last_direction * resource_data.dashSpeed
	else:
		velocity = input_vector * resource_data.speed
	if Input.is_action_just_pressed("Dash"):
		start_dash()
	move_and_slide()

	# Flip sprite if moving left/right
	### Später zur rotation der Waffe ändern
	print(gun.rotation)
	if gun.rotation >= 90 and gun.rotation <= 270:
		player_anim.flip_h = true
	else:
		player_anim.flip_h = false
		
func start_dash() -> void:
	resource_data.is_dashing = true
	velocity = resource_data.last_direction * resource_data.dashSpeed

	# Play dash animation
	player_anim.play("Dash")

	# Disable hurtbox detection and gun during dash
	hurtbox.monitoring = false
	hurtbox.monitorable = false
	gun.hide()

	# Start the timer for the dash
	timer.start()

func end_dash() -> void:
	resource_data.is_dashing = false

	# Re-enable hurtbox and gun
	hurtbox.monitoring = true
	hurtbox.monitorable = true
	gun.visible = true

	# Switch back to walk or idle depending on input
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir == Vector2.ZERO:
		player_anim.play("Idle")
	else:
		player_anim.play("Run")

func take_damage(amount: int) -> void:
	resource_data.health -= amount
	print("%s took %d damage, HP left: %d" % [name, amount, resource_data.health])
	if resource_data.health <= 0:
		die()

func die() -> void:
	print("kill")
	queue_free()

func _play_walk_animation() -> void:
	if player_anim.animation != "Run":
		player_anim.play("Run")

func _play_idle_animation() -> void:
	if player_anim.animation != "Idle":
		player_anim.play("Idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot_1") and resource_data.is_dashing == false:
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - gun.muzzle.global_position).normalized()
		gun.fire(dir)
	if event.is_action_pressed("Escape") and resource_data.can_pause == true:
		pause()

func _on_timer_timeout() -> void:
	end_dash()

func toggle_node(node): #Function to disable a node (for later purposes)
	resource_data.is_disabled = false

	if node.is_disabled:
		node.visible = false                # Hide the node
		node.set_process(false)             # Stop _process()
		node.set_physics_process(false)     # Stop _physics_process()
	else:
		node.visible = true
		node.set_process(true)
		node.set_physics_process(true)
