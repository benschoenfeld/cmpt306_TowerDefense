class_name HUD

extends Control
## Displays the [ToolUI], [SeedBag], and [MoneyCounter] for the player.

signal started_wave

@export_category("Local Nodes")
## A reference to the [ToolUI].
@export var tool_ui: ToolUI

## A reference to the [NumberDisplay] that displays health.
@export var health_display: NumberDisplay

## A reference to the [NumberDisplay] that displays money.
@export var money_display: NumberDisplay

## A reference to the [SeedBag].
@export var seed_bag: SeedBag

## A reference to the [TowerBag].
@export var tower_bag: TowerBag

## A refernce to a [Button] that starts an enemy wave.
@export var wave_button: Button

@export var wave_display: NumberDisplay

@export_category("Outside Nodes")
## A reference to the [GameManager].
@export var manager: GameManager


## Give the enum for tools that can be shared between scenes.
var tool_enum: ToolEnums = ToolEnums.new()

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
	health_display.set_context("Health:")
	health_display.display_amount(new_amount)

## Emits a signal to start the next wave.
func _on_start_wave_button_pressed() -> void:
	wave_button.hide()
	started_wave.emit()

## Emits a signal when a wave has completed.
func _on_wave_finished(has_more_waves: bool) -> void:
	if has_more_waves:
		wave_button.show()
	else:
		wave_button.hide()

## Updates the wave count after each wave.
func update_wave_display(number: int) -> void:
	wave_display.display_amount(number)

##
func _on_tool_manager_request_tower_bag(show_item: bool) -> void:
	tower_bag.visible = show_item
