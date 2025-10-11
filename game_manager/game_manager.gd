class_name GameManager

extends Node
## This is the scene that puts together game machanics.

## Emits the new amount of money.
signal money_changed(new_amount: int)

## A [PackedScene] of the [PauseMenu].
@export var pause_menu_scene: PackedScene

## The [CanvasLayer] that the pause scene will be added to.
@export var pause_menu_layer: CanvasLayer

## The players resource.
var money_amount: int = 0

## Sets the [param money_amount] and emits a signal.
func set_money(new_amount: int) -> void:
	money_amount = new_amount
	money_changed.emit(money_amount)

## Adds to the [param money_amount].
func add_money(new_amount: int) -> void:
	set_money(get_money() + new_amount)

## Returns the [param money_amount]
func get_money() -> int:
	return money_amount

## When the pause button is pressed is adds the pause scene to 
## the [param pause_menu_layer].
func _on_pause_button_pressed() -> void:
	var pause_menu: PauseMenu = pause_menu_scene.instantiate()
	pause_menu_layer.add_child(pause_menu)
