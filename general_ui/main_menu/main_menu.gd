class_name MainMenu

extends Control
## Main menu scene.
##
## The main menu scene allows the user to start the game or open
## up the options menu or quit the game.

## The [PackedScene] that the tree will be changed to once the 
## user hits the start button.
@export var _starting_game_scene: PackedScene

## The [PackedScene] that will change to the tutorial if the user has not 
## finished the tutorial.
@export var _tutorial_scene: PackedScene

## A reference to the [OptionsMenu].
@export var _options: OptionsMenu

## Sets the cursor to the OS default.
func _ready() -> void:
	Input.set_custom_mouse_cursor(null)

## Changes the [Tree] to a difference scene once user hits start button.
func _on_start_button_pressed() -> void:
	if GlobalFlags.did_tutorial:
		get_tree().change_scene_to_packed(_starting_game_scene)
	else:
		get_tree().change_scene_to_packed(_tutorial_scene)

## Shows the [OptionsMenu] once user hits options button.
func _on_options_button_pressed() -> void:
	_options.show_or_hide(true)

## Quits the game once user hits quit button.
func _on_quit_button_pressed() -> void:
	get_tree().quit()
