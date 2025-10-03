class_name MainMenu

extends Control
## Main menu scene.
##
## The main menu scene allows the user to start the game or open
## up the options menu or quit the game.

## The [PackedScene] that the tree will be changed to once the 
## user hits the start button.
@export var _starting_game_scene: PackedScene

## The [PackedScene] that will be added to the tree once the user
## hits the options button.
@export var _options_menu_scene: PackedScene

## [CanvasLayer] for the option menu to be added to.
@onready var options_layer = $OptionsLayer

## Changes the [Tree] to a difference scene once user hits start button.
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(_starting_game_scene)

## Adds [OptionsMenu] to the [param options_layer] once user hits options button.
func _on_options_button_pressed() -> void:
	var options = _options_menu_scene.instantiate()
	options_layer.add_child(options)

## Quits the game once user hits quit button.
func _on_quit_button_pressed() -> void:
	get_tree().quit()
