extends Node
# ============================================================
# === PAUSE MANAGER (GLOBAL) ================================
# Handles pausing/unpausing logic, UI visibility, and signals.
# ============================================================

var is_paused: bool = false
@onready var pause_menu: Control = null

signal pause_changed(is_paused: bool)

func _ready():
	# Optional: automatically find the pause menu if it's in the scene
	print(has_node("/root/Main/PauseMenu"))
	if has_node("/root/Main/PauseMenu"):
		pause_menu = get_node("/root/Main/PauseMenu")

func toggle_pause() -> void:
	if is_paused:
		unpause()
	else:
		pause()

func pause() -> void:
	is_paused = true
	get_tree().paused = true
	if pause_menu:
		pause_menu.visible = true
	emit_signal("pause_changed", true)
	print("Game paused.")

func unpause() -> void:
	is_paused = false
	get_tree().paused = false
	if pause_menu:
		pause_menu.visible = false
	emit_signal("pause_changed", false)
	print("Game unpaused.")
