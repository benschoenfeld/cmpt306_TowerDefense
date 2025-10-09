class_name NumberSlider

extends Control
## A slider that returns the value of the slider and displays it.

## Emits with the [param current_value] is changed.
signal value_changed

## The [float] value that is changed by the slider.
@export_range(0.0, 1.0, 0.001) var current_value: float = 1.0

@export_category("NumberSlider Nodes")
## The [HSlider] node that changes the [param current_value].
@export var _value_slider: HSlider

## A [Label] that shows the [param current_value]
@export var _value_label: Label

## Updates the [param value_slider], [param current_value],and [param value_label]
func value_match(new_amount: float) -> void:
	_value_slider.value = new_amount
	set_value(new_amount)
	_change_value_label()

## Sets the [param current_value] to a new float.
func set_value(new_amount: float) -> void:
	current_value = new_amount

## Returns a the [param current_value].
func get_value() -> float:
	return current_value

## Changes the displayed [param current_value] as the user drags the slide.
func _on_value_slider_drag_started() -> void:
	_change_value_label()

## Changes the [param current_value] when slider value is changed.
func _on_value_slider_value_changed(value: float) -> void:
	current_value = value
	_change_value_label()
	emit_signal("value_changed", current_value)

## A private function so that the [param value_label] can change.
func _change_value_label() -> void:
	_value_label.text = str(round(current_value * 100)) + "%"
