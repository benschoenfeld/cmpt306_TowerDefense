class_name ToolBase

extends Node2D
## A base script for other tools.
##
## A script that will be extended to have different interactions with [BaseTile].

##
@export var sound_effect: AudioStream

##
@onready var sound_player: AudioStreamPlayer = $SoundEffect

func _ready() -> void:
	set_sound_effect(sound_effect)

##
func interact_effect(_tile: BaseTile):
	pass

##
func set_sound_effect(new_sound_effect: AudioStream):
	sound_player.stream = new_sound_effect 

##
func set_sound_volume(new_sound_volume: float):
	sound_player.volume_linear = new_sound_volume
