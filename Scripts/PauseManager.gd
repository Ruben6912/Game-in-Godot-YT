extends Node
# ============================================================
# ============ PAUSE MANAGER (GLOBAL) =======================
# Handles pausing/unpausing logic, UI visibility, and signals.
# ============================================================

var is_paused: bool = false
@onready var pause_menu: Control = null
@onready var resume_button: Button = null

signal pause_changed(is_paused: bool)

func _ready():
	# automatically find the pause menu if it's in the scene
	if has_node("/root/Main/UI/CanvasLayer/PauseMenu"):
		pause_menu = get_node("/root/Main/UI/CanvasLayer/PauseMenu")
	else: 
		print("failed to find pause_menu")
	if has_node("/root/Main/UI/CanvasLayer/PauseMenu/MarginContainer/MarginContainer/Outline/MarginContainer4/VBoxContainer/HBoxContainer/ResumeGameButton"):
		resume_button = get_node("/root/Main/UI/CanvasLayer/PauseMenu/MarginContainer/MarginContainer/Outline/MarginContainer4/VBoxContainer/HBoxContainer/ResumeGameButton")
		resume_button.connect("pressed", _on_ResumeGameButton_pressed_test)

func _on_ResumeGameButton_pressed_test():
	unpause()
	print("Hi")

func toggle_pause() -> void:
	if is_paused:
		unpause()
	else:
		pause()

func pause() -> void:
	is_paused = true
	if pause_menu:
		pause_menu.visible = true
	get_tree().paused = true
	emit_signal("pause_changed", true)
	print("Game paused.")
	

func unpause() -> void:
	is_paused = false
	if pause_menu:
		pause_menu.visible = false
	get_tree().paused = false
	emit_signal("pause_changed", false)
	print("Game unpaused.")
