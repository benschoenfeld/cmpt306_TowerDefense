extends GutTest

var number_slider_scene: PackedScene = preload("res://general_ui/options_menu/number_slider.tscn")
var number_slider: NumberSlider

func before_each():
	number_slider = number_slider_scene.instantiate()
	add_child_autofree(number_slider)

func test_value_match():
	number_slider.value_match(0.4)
	assert_eq(number_slider.current_value, 0.4)

func test_set_value():
	number_slider.set_value(0.4)
	assert_eq(number_slider.current_value, 0.4)

func test_get_value():
	number_slider.set_value(0.4)
	assert_eq(number_slider.get_value(), 0.4)

func test_on_value_slider_drag_started():
	number_slider._on_value_slider_drag_started()
	assert_eq(number_slider._value_label.text, "100.0%")

func test_on_value_slider_value_changed():
	number_slider._on_value_slider_value_changed(0.4)
	assert_eq(number_slider.get_value(), 0.4)

func test_change_value_label():
	number_slider._change_value_label()
	assert_eq(number_slider._value_label.text, "100.0%")
