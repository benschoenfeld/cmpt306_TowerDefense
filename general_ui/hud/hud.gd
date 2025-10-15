class_name HUD
extends CanvasLayer

# fetch game manager class
var manager: GameManager

# fetch currently selected tool
var selected: Tool
@export var tilemap: TileMapLayer

# player money resource
var count: int

# catch selection signals
func _ready() -> void:
	for tool: Tool in $ToolContainer.get_children():
		tool.tool_selected.connect(select_tool)
	manager.money_changed.connect(new_amount)


# update tool view
func _process(delta: float) -> void:
	for tool: Tool in $ToolContainer.get_children():
		tool.update_view(self)

# input handling
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if selected != null:
			selected.apply_effect(tilemap, tilemap.local_to_map(tilemap.to_local(event.global_position)))
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		selected = null

# selects new tool
func select_tool(tool: Tool) -> void:
	selected = tool

# updates money amount
func new_amount(count: int) -> void:
	money_amount = count
