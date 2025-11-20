extends Node2D
class_name HighlightTile

@export var tool_manager: ToolManager

func _process(delta: float) -> void:
	if tool_manager.current_tool_index == tool_manager.tool_enum.Tool.TARGET:
		visible = true
		follow_mouse_position()
	else:
		visible = false
	
func follow_mouse_position() -> void:
	var mouse_pos: Vector2i = get_global_mouse_position() 
	
	position = mouse_pos 
	
