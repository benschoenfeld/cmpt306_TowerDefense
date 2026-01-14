class_name ToolBase

extends Node2D
## A base script for other tools.
##
## A script that will be extended to have different interactions with [BaseTile].

## The sound that will play for the [param sound_player].
@export var sound_effect: AudioStream

## A reference to the [AudioStreamPlayer] that will play [param sound_effect].
@onready var sound_player: AudioStreamPlayer = $SoundEffect

func _ready() -> void:
	set_sound_effect(sound_effect)

## A placeholder for all other scripts to have an interact_effect function.
func interact_effect(_tile: BaseTile):
	pass

## Sets a new sound effect for the [param sound_player].
func set_sound_effect(new_sound_effect: AudioStream):
	sound_player.stream = new_sound_effect 

## Changes the [param sound_player] [member AudioStreamPlayer.volume_linear] to a new float.
func set_sound_volume(new_sound_volume: float):
	sound_player.volume_linear = new_sound_volume
