class_name NumberDisplay

extends Control
## Displays the amount of money a player has

@export var icon: Texture

## The minimun amount that can be displayed. 
@export var min_val = 0

## The maximun amount that can be displayed.
@export var max_val = 99999

##
@export var context_line: String

##
@onready var icon_node: TextureRect = $PanelContainer/PanelContainer/TextureRect

##
@onready var context_label: Label = $PanelContainer/Context

## A reference to a [Label] for displaying a number.
@onready var number_label: Label = $PanelContainer/Number

func _ready() -> void:
	pass

##
func set_icon():
	pass

## 
func set_context(new_context: String):
	pass

## Updates the [param money_label] with an [int] amount.
func display_amount(new_amount: int) -> void:
	var count: int = clamp(new_amount, min_val, max_val)
	number_label.text = str(count)
