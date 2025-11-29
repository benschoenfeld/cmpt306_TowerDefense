class_name HUD

extends Control
## Displays the [ToolUI], [SeedBag], and [MoneyCounter] for the player.

@export_category("Enums")
## Give the enum for tools that can be shared between scenes.
@export var tool_enum: ToolEnums

@export_category("Local Nodes")
## A reference to the [ToolUI].
@export var tool_ui: ToolUI

## A reference to the [NumberDisplay] that displays health.
@export var health_display: NumberDisplay

## A reference to the [NumberDisplay] that displays money.
@export var money_display: NumberDisplay

## A reference to the [SeedBag].
@export var seed_bag: SeedBag

@export_category("Outside Nodes")
## A reference to the [GameManager].
@export var manager: GameManager

## Highlights the currently selected tool and shows [SeedBad] if needed.
func _on_tool_manager_tool_changed(tool_index: int) -> void:
	tool_ui.highlight_tool(tool_index)

## Shows or hides the [SeedBag] based on information given out in a signal.
func _on_tool_manager_request_seed_menu(show_item: bool) -> void:
	seed_bag.visible = show_item

## Updates the [param money_display].
func _on_game_manager_money_changed(new_amount: int) -> void:
	money_display.display_amount(new_amount)

## Updates the [param health_display].
func _on_game_manager_health_change(new_amount: int) -> void:
	health_display.display_amount(new_amount)
