class_name Tutorial

extends Control
## A tutorial for the player to learn how to play the game.

## The content that will be shown to the player.
@export var tutorial_content: Array[TutorialContent]

## The current index of content.
var tutorial_content_index: int = 0

## A reference to a [Button] that goes back to the prevous [param tutorial_content].
@onready var previous_button = $PanelContainer/VBoxContainer/HBoxContainer/PreviousButton

## A reference to a [Button] that goes back to the next [param tutorial_content]
## or finished the tutorial
@onready var next_button = $PanelContainer/VBoxContainer/HBoxContainer/NextButton

## A reference to the text box for the turorial text.
@onready var tutorial_text = $PanelContainer/VBoxContainer/VBoxContainer/HBoxContainer/TutorialText

## A [CanvasLayer] that holds sprites for the animation.
@onready var sprite_holder = $Sprites

## A reference to an [AnimationPlayer].
@onready var anim_player: AnimationPlayer = $AnimationPlayer

## A reference to an [AudioStreamPlayer].
@onready var music_player: AudioStreamPlayer = $Music

func _ready() -> void:
	if !GlobalFlags.did_tutorial:
		start()
	else:
		anim_player.play("not_visable")

# Starts the tutorial off.
func start() -> void:
	music_player.play()
	if tutorial_content.size() > 1:
		tutorial_content_index = 0
		next_button.text = "Next"
		_change_tutorial(tutorial_content_index)

## Switches the tutorial content based on index.
func _change_tutorial(current_index: int) -> void:
	var content: TutorialContent = tutorial_content[current_index]
	tutorial_text.text = content.tutorial_text
	for item in sprite_holder.get_children():
		item.hide()
	anim_player.get_animation_library("").add_animation("tutorial_" + str(current_index), content.animation)
	anim_player.play("tutorial_" + str(current_index))

## Goes back to the previous section of the tutorial.
func _on_previous_button_pressed() -> void:
	tutorial_content_index -= 1
	
	if tutorial_content_index <= 0:
		tutorial_content_index = 0
		previous_button.disabled = true
		
	if tutorial_content_index == tutorial_content.size()-2:
		next_button.text = "Next"
	
	_change_tutorial(tutorial_content_index)

## Moves to the next section of the tutorial.
func _on_next_button_pressed() -> void:
	tutorial_content_index += 1
	
	if tutorial_content_index >= 1:
		previous_button.disabled = false
	
	if tutorial_content_index == tutorial_content.size()-1:
		next_button.text = "Finish"
	
	if tutorial_content_index >= tutorial_content.size():
		_on_skip_button_pressed()
	else:
		_change_tutorial(tutorial_content_index)

## Skips the tutorial.
func _on_skip_button_pressed() -> void:
	if GlobalFlags.did_tutorial:
		anim_player.play("not_visable")
		music_player.stop()
		self.hide()
	else:
		GlobalFlags.did_tutorial = true
		get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")
