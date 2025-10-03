class_name PauseMenu

extends Control
## A pause menu that stops gamplay when opened.
##
## Allows the user to pause the [Tree] when brought in to a [Scene]. User can 
## also unpause the gameplay with a resume button, open up [OptionsMenu] with 
## a button, return to the [MainMenu] with a button, and quit the game with
## a button.

## [CanvasLayer] for the option menu to be added to.
@onready var options_layer = $OptionsLayer

## Unpaused the [Tree] and removes the scene once user hits resume button.
func _on_resume_button_pressed() -> void:
	pass # Replace with function body.

## Adds [OptionsMenu] to the [param options_layer] once user hits options button.
func _on_options_button_pressed() -> void:
	pass # Replace with function body.

## Changes the [Tree] to the [MainMenu] scene once user hits main menu button.
func _on_main_menu_button_pressed() -> void:
	pass # Replace with function body.

## Quits the game once user hits quit button.
func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
