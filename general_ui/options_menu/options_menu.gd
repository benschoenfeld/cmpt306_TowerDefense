class_name OptionsMenu

extends Control
## The options menu allows the user to change game options
##
## This game options menu allows for the changing of music and SFX volume.
##
## @tutorial: https://shaggydev.com/2023/05/22/volume-sliders/
## tutorial used for how to access the audio bus systems and db to linear

## Slider for the music.
@export var music_slider: NumberSlider

## Slider for the sound effects.
@export var sfx_slider: NumberSlider

func _ready() -> void:
	match_sliders_to_audio()

## Sets an [AudioServer] bus to a certain db based on given input.
func set_audio_bus_volume(bus_name: String, new_value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))

## A getter for an [AudioServer] bus db to linear
func get_audio_bus_volume(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))

## Matches the visual on the sliders to match the [AudioServer] bus settings. 
func match_sliders_to_audio() -> void:
	var music_volume = get_audio_bus_volume("Music")
	var sfx_volume = get_audio_bus_volume("SFX")
	music_slider.value_match(music_volume)
	sfx_slider.value_match(sfx_volume)

## Private function to change the audio bus settings for SFX.
func _on_sfx_volume_value_changed(new_value: float) -> void:
	set_audio_bus_volume("SFX", new_value)

## Private function to change the audio bus settings for music.
func _on_music_volume_value_changed(new_value: float) -> void:
	set_audio_bus_volume("Music", new_value)

## Removes self from the scene
func _on_exit_button_pressed() -> void:
	queue_free()
