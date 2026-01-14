class_name GameOverUI

extends Control
## UI for the player to change scene.

## Sets the player game to the main game scene.
func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")

## Changes back to the main menu.
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://general_ui/main_menu/main_menu.tscn")

## Quits the game.
func _on_quit_pressed() -> void:
	get_tree().quit()
