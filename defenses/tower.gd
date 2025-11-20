extends Node2D
class_name Tower

@export var tool_manager: ToolManager

@export var tower_scene = preload("res://defenses/tower_scene.tscn")

@export var required_tool_index: int = 3

@export var grid_size: Vector2 = Vector2(32, 32)

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if tool_manager == null or tower_scene == null:
			return
		if not tool_manager.has_method("get_current_tool"):
			return
		if tool_manager.get_current_tool() != required_tool_index:
			return
		var inst = tower_scene.instantiate()
		var pos = get_global_mouse_position()
		if grid_size.x > 0 and grid_size.y > 0:
			pos = _snap_position(pos)	
		inst.position = pos
		add_child(inst)
		
		
func _snap_position(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / grid_size.x) * grid_size.x,
					round(pos.y / grid_size.y) * grid_size.y)
