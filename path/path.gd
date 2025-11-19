extends Control

@export var target = preload("res://path/assets/target_round_a.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(target)

func _on_retreat_pressed() -> void:
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn") # Replace with function body.
