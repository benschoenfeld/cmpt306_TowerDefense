class_name PauseMenu

extends Control
## A pause menu that stops gamplay when opened.
##
## Allows the user to pause the [Tree] when brought in to a [Scene]. User can 
## also unpause the gameplay with a resume button, open up [OptionsMenu] with 
## a button, return to the [MainMenu] with a button, and quit the game with
## a button.

## A reference to the [ToolManager] to interact with [PauseMenu].
@export var tool_manager: ToolManager

## Constant path that is the [MainMenu]
const MAIN_MENU_PATH: String = "res://general_ui/main_menu/main_menu.tscn"

## [CanvasLayer] for the option menu to be added to.
@export var options: OptionsMenu

## A reference to the sound for opening and closing the menu.
@export var open_close_sound: AudioStreamPlayer

## Pauses or unpauses the game based on a [bool].
func set_pause(pause: bool):
	
	open_close_sound.play()
	self.visible = pause
	get_tree().paused = pause
	
	if pause:
		Input.set_custom_mouse_cursor(null)
	else:
		if tool_manager != null:
			tool_manager.set_current_tool(tool_manager.get_current_tool())
	

## Unpaused the [Tree] and removes the scene once user hits resume button.
## Sets the custom cursor from null(default) back to the selected tool icon 
func _on_resume_button_pressed() -> void:
	set_pause(false)

## Adds [OptionsMenu] to the [param options_layer] once user hits options button.
func _on_options_button_pressed() -> void:
	options.show_or_hide(true)

## Changes the [Tree] to the [MainMenu] scene once user hits main menu button.
func _on_main_menu_button_pressed() -> void:
	set_pause(false)
	get_tree().change_scene_to_file(MAIN_MENU_PATH)

## Quits the game once user hits quit button.
func _on_quit_button_pressed() -> void:
	get_tree().quit()
