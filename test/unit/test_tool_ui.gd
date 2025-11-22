extends GutTest

var tool_ui_scene: PackedScene = preload("res://general_ui/hud/ToolUI.tscn")
var tool_ui: ToolUI

func before_each():
	tool_ui = tool_ui_scene.instantiate()
	add_child_autofree(tool_ui)

func test_deselect_all():
	tool_ui.deselect_all()
	for icon in tool_ui.tool_bar.get_children():
		assert_eq(icon.modulate, tool_ui.DESELECTION_COLOR)

func test_highlight_tool():
	tool_ui.highlight_tool(0)
	assert_eq(tool_ui.shovel_image.modulate, tool_ui.SELECTION_COLOR)
	assert_eq(tool_ui.watercan_image.modulate, tool_ui.DESELECTION_COLOR)
	assert_eq(tool_ui.hoe_image.modulate, tool_ui.DESELECTION_COLOR)
	
	tool_ui.highlight_tool(1)
	assert_eq(tool_ui.shovel_image.modulate, tool_ui.DESELECTION_COLOR)
	assert_eq(tool_ui.watercan_image.modulate, tool_ui.SELECTION_COLOR)
	assert_eq(tool_ui.hoe_image.modulate, tool_ui.DESELECTION_COLOR)
	
	tool_ui.highlight_tool(2)
	assert_eq(tool_ui.shovel_image.modulate, tool_ui.DESELECTION_COLOR)
	assert_eq(tool_ui.watercan_image.modulate, tool_ui.DESELECTION_COLOR)
	assert_eq(tool_ui.hoe_image.modulate, tool_ui.SELECTION_COLOR)
