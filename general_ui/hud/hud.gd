class_name HUD
extends Control

@export_category("Enums")
## Give the enum for tools that can be shared between scenes.
@export var tool_enum: ToolEnums

@export_category("Local Nodes")
## A reference to the [ToolUI].
@export var tool_ui: ToolUI

## A reference to the [SeedBag].
@export var seed_bag: SeedBag

@export_category("Outside Nodes")
# fetch game manager class
@export var manager: GameManager

## Highlights the currently selected tool and shows seed bag if needed.
func _on_tool_manager_tool_changed(tool_index: int) -> void:
	tool_ui.highlight_tool(tool_index)

## Shows or hides the [SeedBag] based on information given out in a signal.
func _on_tool_manager_request_seed_menu(show: bool) -> void:
	seed_bag.visible = show
