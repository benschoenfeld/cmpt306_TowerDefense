class_name GameManager

extends Node
## This is the scene that puts together game machanics.

##
@export var pause_menu_scene: PackedScene

##
@export var pause_menu_layer: CanvasLayer

##
func _on_pause_button_pressed() -> void:
	var pause_menu: PauseMenu = pause_menu_scene.instantiate()
	pause_menu_layer.add_child(pause_menu)
