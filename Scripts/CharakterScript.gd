extends CharacterBody2D
# ============================================================
# === PLAYER SCRIPT (TOP-DOWN ROGUELIKE) =====================
# Handles movement, dashing, shooting, animations, and connects
# with the global PauseManager for pausing logic.
# ============================================================

@export var resource_data: PlayerData     # Player stats (speed, health, etc.)

# --- Node references ---
@onready var gun: Node2D = $Gun
@onready var gun_animator: AnimatedSprite2D = $Gun/AnimatedSprite2D
@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var hurtbox: Area2D = $Hurtbox

# ============================================================
# === PLAYER STATE MACHINE ==================================
# ============================================================
# We use this instead of scattered if-statements.
# Makes it easy to add states later (e.g., Attack, Dead, etc.)
enum CharState { IDLE, RUN, DASH }
var state: CharState = CharState.IDLE

func set_state(new_state: CharState) -> void:
	if state == new_state:
		return
	state = new_state

	match state:
		CharState.IDLE:
			player_anim.play("Idle")
		CharState.RUN:
			player_anim.play("Run")
		CharState.DASH:
			player_anim.play("Dash")

# ============================================================
# === MAIN MOVEMENT LOOP =====================================
# ============================================================
func _physics_process(_delta: float) -> void:
	# Don't process movement if the game is paused
	if PauseManager.is_paused:
		return

	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_position

	# Update gun rotation to face the mouse
	gun.look_at(mouse_pos)

	# --- STATE BEHAVIOR LOGIC ---
	match state:
		CharState.DASH:
			velocity = resource_data.last_direction * resource_data.dashSpeed
		_:
			if input_vector != Vector2.ZERO:
				velocity = input_vector.normalized() * resource_data.speed
				resource_data.last_direction = input_vector.normalized()
				set_state(CharState.RUN)
			else:
				velocity = Vector2.ZERO
				set_state(CharState.IDLE)

	move_and_slide()

	# --- Input to start dash ---
	if Input.is_action_just_pressed("Dash") and state != CharState.DASH:
		start_dash()

	# --- Handle sprite direction ---
	_update_sprite_orientation(mouse_pos, player_pos)


# ============================================================
# === DASH HANDLING ==========================================
# ============================================================
func start_dash() -> void:
	resource_data.is_dashing = true
	set_state(CharState.DASH)

	# Disable damage and hide gun
	hurtbox.monitoring = false
	hurtbox.monitorable = false
	gun.hide()

	# Start dash timer
	timer.start()

func end_dash() -> void:
	resource_data.is_dashing = false
	hurtbox.monitoring = true
	hurtbox.monitorable = true
	gun.show()

	# Go back to idle or run
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector == Vector2.ZERO:
		set_state(CharState.IDLE)
	else:
		set_state(CharState.RUN)

func _on_timer_timeout() -> void:
	end_dash()

# ============================================================
# === DAMAGE & DEATH =========================================
# ============================================================
func take_damage(amount: int) -> void:
	resource_data.health -= amount
	print("%s took %d damage, HP left: %d" % [name, amount, resource_data.health])
	if resource_data.health <= 0:
		die()

func die() -> void:
	print("Player has died.")
	queue_free()


# ============================================================
# === INPUT HANDLING =========================================
# ============================================================
func _input(event: InputEvent) -> void:
	# Shoot (only if not dashing or paused)
	if event.is_action_pressed("Shoot_1") and not resource_data.is_dashing and not PauseManager.is_paused:
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - gun.muzzle.global_position).normalized()
		gun.fire(dir)

	# Pause input — handled through the PauseManager
	if event.is_action_pressed("Escape"):
		PauseManager.toggle_pause()


# ============================================================
# === HELPER FUNCTIONS =======================================
# ============================================================
func _update_sprite_orientation(mouse_pos: Vector2, player_pos: Vector2) -> void:
	if mouse_pos.x > player_pos.x:
		player_anim.flip_h = false
		gun_animator.flip_v = false
		gun_animator.offset = Vector2(48, -38)
		gun.position = Vector2(3, 1)
	else:
		player_anim.flip_h = true
		gun_animator.flip_v = true
		gun_animator.offset = Vector2(48, 38)
		gun.position = Vector2(-3, 1)
