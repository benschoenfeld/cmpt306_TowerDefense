class_name PauseMenu

extends Control
## A pause menu that stops gamplay when opened.
##
## Allows the user to pause the [Tree] when brought in to a [Scene]. User can 
## also unpause the gameplay with a resume button, open up [OptionsMenu] with 
## a button, return to the [MainMenu] with a button, and quit the game with
## a button.

## Constant path that is the [MainMenu]
const MAIN_MENU_PATH: String = "res://general_ui/main_menu/main_menu.tscn"

## The [PackedScene] that will be added to the tree once the user
## hits the options button.
@export var _options_menu_scene: PackedScene

## [CanvasLayer] for the option menu to be added to.
@export var options_layer: CanvasLayer

## Pauses the game once spawned into the [Tree].
func _ready() -> void:
	set_pause(true)

## Pauses or unpauses the game based on a [bool].
func set_pause(pause: bool):
	get_tree().paused = pause

## Unpaused the [Tree] and removes the scene once user hits resume button.
func _on_resume_button_pressed() -> void:
	set_pause(false)
	queue_free()

## Adds [OptionsMenu] to the [param options_layer] once user hits options button.
func _on_options_button_pressed() -> void:
	var options = _options_menu_scene.instantiate()
	options_layer.add_child(options)

## Changes the [Tree] to the [MainMenu] scene once user hits main menu button.
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_PATH)

## Quits the game once user hits quit button.
func _on_quit_button_pressed() -> void:
	get_tree().quit()
