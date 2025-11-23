class_name MoneyCounter

extends Control
## Displays the amount of money a player has

## A reference to the money [Label] for displaying the amount of money.
@export var money_label: Label

## The minimun amount that can be displayed. 
var min_val = 0

## The maximun amount that can be displayed.
var max_val = 99999

## Updates the [param money_label] with an [int] amount.
func display_amount(new_amount: int) -> void:
	var count: int = clamp(new_amount, min_val, max_val)
	money_label.text = str(count)
