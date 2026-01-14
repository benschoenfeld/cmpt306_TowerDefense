class_name ToolUI

extends Control
## Allows for highlighting of a current tool.

const SELECTION_COLOR = Color(1.0, 1.0, 0.0, 1.0)
const DESELECTION_COLOR = Color(1.0, 1.0, 1.0, 1.0)

@export_category("Tool Textures")
## A [TextureRect] of the shovel tool.
@export var shovel_image: TextureRect

## A [TextureRect] of the watercan tool.
@export var watercan_image: TextureRect

## A [TextureRect] of of the hoe tool.
@export var hoe_image: TextureRect

## A [TextureRect] of of the target tool.
@export var target_image: TextureRect

## Where all the tool icons can be found as [TextureRect].
@export var tool_bar: HBoxContainer

## Give the enum for tools that can be shared between scenes.
var tool_enum: ToolEnums = ToolEnums.new()

## Turns off all visual selection of the tools.
func deselect_all() -> void:
	for texture in tool_bar.get_children():
		if texture is TextureRect:
			texture.modulate = DESELECTION_COLOR

## Visually shows a selection of the current tool.
func highlight_tool(current_tool: int) -> void:
	deselect_all()
	match current_tool:
		int(tool_enum.Tool.SHOVEL):
			shovel_image.modulate = SELECTION_COLOR
		
		int(tool_enum.Tool.WATERCAN):
			watercan_image.modulate = SELECTION_COLOR
		
		int(tool_enum.Tool.HOE):
			hoe_image.modulate = SELECTION_COLOR
			
		int(tool_enum.Tool.TARGET):
			target_image.modulate = SELECTION_COLOR
