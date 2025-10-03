class_name NumberSlider

extends Control
## A slider that returns the value of the slider and displays it.

## The [float] value that is changed by the slider.
@export_range(0.0, 100.0, 1.0) var current_value: float = 100.0

## The [HSlider] node that changes the [param current_value].
@onready var value_slider = $HBoxContainer/ValueSlider

## A [Label] that shows the [param current_value]
@onready var value_label = $HBoxContainer/Percentage

func _ready() -> void:
	value_slider.value = current_value

## Sets the [param current_value] to a new float.
func set_value(new_amount: float) -> void:
	current_value = new_amount

## Returns a the [param current_value].
func get_value() -> float:
	return current_value

## Changes the displayed [param current_value] as the user drags the slide.
func _on_value_slider_drag_started() -> void:
	value_label.text = str(value_slider.value) + "%"

## Changes the [param current_value] when slider value is changed.
func _on_value_slider_value_changed(value: float) -> void:
	current_value = value
	value_label.text = str(current_value) + "%"
