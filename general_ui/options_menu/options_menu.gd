class_name OptionsMenu

extends Control

var main: MainMenu = MainMenu.new()
var pause: PauseMenu = PauseMenu.new()
func _ready() -> void:
	main._on_options_button_pressed()
	pause._on_resume_button_pressed()
