extends Node2D
class_name Defense

@export var tool_manager: ToolManager

@export var required_tool_index: int

@export var grid_size: Vector2 = Vector2(32, 32)

#@export var defense_sound: AudioStreamPlayer2D  #TODO


func _ready() -> void:
	if (required_tool_index == 0 or required_tool_index == -1) and tool_manager:
		required_tool_index = int(tool_manager.tool_enum.Tool.TARGET)

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		if tool_manager == null:
			print("DEBUGG Tower: current_tool = ", tool_manager.get_current_tool(), "required = ", required_tool_index, "selected_tower = ", tool_manager.get_selected_tower() if tool_manager.has_method("get_selected_tower") else tool_manager.selected_tower)

		
		if not tool_manager.has_method("get_current_tool"):
			return
		if tool_manager.get_current_tool() != required_tool_index:
			return
		
		
		var defenseRes: DefenseResource = null
		if tool_manager.has_method("get_selected_defense"):
			defenseRes = tool_manager.get_selected_defense()
		else:
			return
		
		if defenseRes == null:
			return
		
		#check money
		#if not _can_afford(towerRes.cost):
			#print("Not enough moeny for: ", towerRes.tower_name, " cost:", towerRes.cost)
			#return
			
		var pos = get_global_mouse_position()
		if grid_size.x > 0 and grid_size.y > 0:
			pos = _snap_position(pos)
			
		
		if defenseRes.defense_scene == null:
			push_error("DefenseResource has no individual scene assigned")
			return
		
		var defense_instance = defenseRes.defense_scene.instantiate()
		if defense_instance == null:
			push_error("Failed to instantiated defense scene")
			return
		
		defense_instance.position = pos
		add_child(defense_instance)
		print("Defense placed at ", pos)
		
		# deduct money for the cost of building tower
		#_spend_money(towerRes.cost)
		
		

	

func _snap_position(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / grid_size.x) * grid_size.x,
					round(pos.y / grid_size.y) * grid_size.y)


func _on_tool_manager_selected_defense_changed(defenseRes: DefenseResource) -> void:
	pass # Replace with function body.
