extends MarginContainer

@export var Startingscreen: MarginContainer 
@export var GameMenuScreen: MarginContainer
@export var SettingsMenuScreen: MarginContainer

@export var Setting_VideoGameMenu_MenuScreen: MarginContainer
@export var Setting_AudioMenu_MenuScreen: MarginContainer

@export var Setting_ControllMenu_MenuScreen: MarginContainer
@export var Setting_ControllMenu_Controller_MenuScreen: MarginContainer
@export var Setting_ControllMenu_Keyboard_MenuScreen: MarginContainer

func toggle_visibility(object):
	
	if object.visible:
		object.visible = false
	else: 
		object.visible = true

#Back to the Game Menu
func _on_start_game_button_pressed() -> void:
	toggle_visibility(Startingscreen)
	toggle_visibility(GameMenuScreen)

#Back to the Starting Screen
func _on_back_menu_button_pressed() -> void: 
	if (GameMenuScreen.visible == true):   #From the Game Menu to the Starting Screen
		toggle_visibility(Startingscreen)
		toggle_visibility(GameMenuScreen)
	elif (SettingsMenuScreen.visible == true):   #From the Settings Menu to the Starting Screen
		toggle_visibility(SettingsMenuScreen)
		toggle_visibility(Startingscreen)
	elif (Setting_VideoGameMenu_MenuScreen.visible == true):
		toggle_visibility(SettingsMenuScreen)
		toggle_visibility(Setting_VideoGameMenu_MenuScreen)
		
		
	elif (Setting_ControllMenu_MenuScreen.visible == true):
		toggle_visibility(SettingsMenuScreen)
		toggle_visibility(Setting_ControllMenu_MenuScreen)
	elif (Setting_ControllMenu_Controller_MenuScreen.visible == true):
		toggle_visibility(Setting_ControllMenu_MenuScreen)
		toggle_visibility(Setting_ControllMenu_Controller_MenuScreen)
	elif (Setting_ControllMenu_Keyboard_MenuScreen.visible == true):
		toggle_visibility(Setting_ControllMenu_MenuScreen)
		toggle_visibility(Setting_ControllMenu_Keyboard_MenuScreen)
		
		
	elif (Setting_AudioMenu_MenuScreen.visible == true):
		toggle_visibility(SettingsMenuScreen)
		toggle_visibility(Setting_AudioMenu_MenuScreen)

#Settings Menu 
func _on_settings_button_pressed() -> void:
	toggle_visibility(SettingsMenuScreen)
	toggle_visibility(Startingscreen)
func _on_video_game_settings_button_pressed() -> void:
	toggle_visibility(SettingsMenuScreen)
	toggle_visibility(Setting_VideoGameMenu_MenuScreen)
#func _on_fps_checkbox_30_toggled(toggled_on: bool) -> void:
	#fps_checkbox_60.toggle_mode = false
	#fps_checkbox_max.toggle_mode = false
#func _on_fps_checkbox_60_toggled(toggled_on: bool):
	#fps_checkbox_30.toggle_mode = false
	#fps_checkbox_max.toggle_mode = false
#func _on_fps_checkbox_max_toggled(toggled_on: bool) -> void:
	#fps_checkbox_30.toggle_mode = false
	#fps_checkbox_30.to
	#fps_checkbox_60.toggle_mode = false

func _on_audio_settings_pressed() -> void:
	toggle_visibility(SettingsMenuScreen)
	toggle_visibility(Setting_AudioMenu_MenuScreen)
func _on_controll_settings_pressed() -> void:
	toggle_visibility(SettingsMenuScreen)
	toggle_visibility(Setting_ControllMenu_MenuScreen)
func _on_keyboard_button_pressed() -> void:
	toggle_visibility(Setting_ControllMenu_MenuScreen)
	toggle_visibility(Setting_ControllMenu_Keyboard_MenuScreen)
func _on_controller_button_pressed() -> void:
	toggle_visibility(Setting_ControllMenu_MenuScreen)
	toggle_visibility(Setting_ControllMenu_Controller_MenuScreen)

#Exit Game
func _on_exit_game_pressed() -> void:
	get_tree().quit()


func _ready() -> void:
	set_process_unhandled_key_input(false)


func hotkey_rebind() -> void: 
	pass
