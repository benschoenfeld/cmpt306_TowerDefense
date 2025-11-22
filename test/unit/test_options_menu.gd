extends GutTest

var options_menu_scene: PackedScene = preload("res://general_ui/options_menu/options_menu.tscn")
var options_menu: OptionsMenu

func before_each():
	options_menu = options_menu_scene.instantiate()
	add_child_autofree(options_menu)

func test_set_audio_bus_volume():
	for bus_type: String in ["Music", "SFX"]:
		options_menu.set_audio_bus_volume(bus_type, 0.3)
		assert_almost_eq(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(bus_type)), 0.3, 0.1)

func test_get_audio_bus_volume():
	for bus_type: String in ["Music", "SFX"]:
		options_menu.set_audio_bus_volume(bus_type, 0.3)
		assert_almost_eq(options_menu.get_audio_bus_volume(bus_type), 0.3, 0.1)

func test_match_sliders_to_audio():
	for bus_type: String in ["Music", "SFX"]:
		options_menu.set_audio_bus_volume(bus_type, 0.3)
	assert_almost_eq(options_menu.music_slider.current_value, 0.3, 0.1)
	assert_almost_eq(options_menu.sfx_slider.current_value, 0.3, 0.1)

func test_show_or_hide():
	options_menu.show_or_hide(false)
	assert_eq(options_menu.visible, false)
	
	options_menu.show_or_hide(true)
	assert_eq(options_menu.visible, true)
