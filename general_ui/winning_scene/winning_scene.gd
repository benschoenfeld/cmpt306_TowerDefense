class_name WinningScene

extends Control


func _ready() -> void:
	get_tree().paused = true

func _on_play_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://general_ui/main_menu/main_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
