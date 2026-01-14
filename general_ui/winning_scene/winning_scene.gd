class_name WinningScene

extends Control
## A winning screen to show the player that the game is over.

## Pause the game since it is over.
func _ready() -> void:
	get_tree().paused = true

## Brings the player back to the start of the game loop [GameManager] scene.
func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")

## Brings the player to the [MainMenu].
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://general_ui/main_menu/main_menu.tscn")

## Quits the game.
func _on_quit_button_pressed() -> void:
	get_tree().quit()
