class_name SimpleToolTip

extends Control
## Displays text.

## The text that will be shown.
@export_multiline var text: String

## Displays the [param text].
@onready var text_label: Label = $PanelContainer/Label

func _ready() -> void:
	text_label.text = text

## Set the text to be displayed.
func set_text(message: String) -> void:
	text = message
	text_label.text = message
