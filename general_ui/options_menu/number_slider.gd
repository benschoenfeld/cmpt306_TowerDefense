class_name NumberSlider

extends Control
## A slider that returns the value of the slider and displays it.

## The [float] value that is changed by the slider.
var value: float = 100.0

## The [HSlider] node that changes the [param value].
@onready var value_slider = $HBoxContainer/ValueSlider

## A [Label] that shows the [param value]
@onready var value_label = $HBoxContainer/Percentage

## Sets the [param value] to a new float.
func set_value(new_amount: float) -> void:
	pass

## Returns a the [param value].
func get_value() -> float:
	return value

## Changes the [param value] when the slider is dropped.
func _on_value_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.

## Changes the displayed [param value] as the user drags the slide.
func _on_value_slider_drag_started() -> void:
	pass # Replace with function body.
