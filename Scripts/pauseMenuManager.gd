extends MarginContainer
enum signals {_resumeGameButton_pressed}

func _on_resume_game_button_pressed() -> void:
	print("test")
	emit_signal("pressed")
