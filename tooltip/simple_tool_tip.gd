class_name SimpleToolTip

extends Control
## Displays text.

## The text that will be shown.
@export_multiline var text: String

## Displays the [param text].
@onready var text_label: Label = $PanelContainer/Label

func _ready() -> void:
	text_label.text = text
