extends MarginContainer

@onready var margin_container: MarginContainer = $MarginContainer

func _on_resume_game_button_pressed() -> void:
	margin_container.visible = false


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_game_button_pressed() -> void:
	pass # Replace with function body.
