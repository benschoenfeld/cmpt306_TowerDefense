class_name NumberDisplay

extends Control
## Displays the amount of money a player has

## A path to a Texture.
@export var icon: Texture

## The minimun amount that can be displayed. 
@export var min_val = 0

## The maximun amount that can be displayed.
@export var max_val = 99999

## A [String] that shows what the number means. EX: Money:
@export var context_line: String

## A reference to a [TextureRect] for displaying an icon.
@onready var icon_node: TextureRect = $PanelContainer/PanelContainer/TextureRect

## A reference to a [Label] for displaying a context to a number. EX: How much money
@onready var context_label: Label = $PanelContainer/Context

## A reference to a [Label] for displaying a number.
@onready var number_label: Label = $PanelContainer/Number

func _ready() -> void:
	set_icon(icon)
	set_context(context_line)

## Sets the [param icon_node] with a new texture
func set_icon(new_icon: Texture):
	icon_node.texture = new_icon

## Sets the [param context_line] and visually update the [param context_label] text.
func set_context(new_context: String):
	context_line = new_context
	context_label.text = new_context

## Updates the [param number_label] with an [int] amount.
func display_amount(new_amount: int) -> void:
	var count: int = clamp(new_amount, min_val, max_val)
	number_label.text = str(count)
