class_name OptionsMenu

extends Control
## The options menu allows the user to change game options
##
## This game options menu allows for the changing of music and SFX volume.
##
## @tutorial: https://shaggydev.com/2023/05/22/volume-sliders/
## tutorial used for how to access the audio bus systems and [method GlobalScope.linear_to_db]

func _ready() -> void:
	pass

## Sets an [AudioServer] bus to a certain db based on given input.
func set_audio_bus(bus_name: String) -> void:
	pass

## Matches the visual on the sliders to match the [AudioServer] bus settings. 
func _match_sliders_to_audio() -> void:
	pass

## Private function to change the audio bus settings for SFX.
func _on_sfx_volume_value_changed() -> void:
	pass # Replace with function body.

## Private function to change the audio bus settings for music.
func _on_music_volume_value_changed() -> void:
	pass # Replace with function body.
