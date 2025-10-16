extends Control

@onready var tools = [
	$HBoxContainer/Shovel,
	$HBoxContainer/WaterCan,
	$HBoxContainer/Hoe
]

const BG_select = Color(1, 1, 0, 0.85)
const BG_unselect = Color(1, 1, 1, 0.0)

func _ready() -> void:
	for tool in tools:
		var tool_icon = tool.get_node("Icon") as TextureRect
		tool_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tool.get_node("BG").color = BG_unselect
	set_selected(0)
	
func set_selected(index: int) -> void:
	index = clamp(index, 0, tools.size() - 1)
	for i in range(tools.size()):
		var bg = tools[i].get_node("BG") as ColorRect
		if i == index:
			bg.color = BG_select
		else:
			bg.color = BG_unselect 
