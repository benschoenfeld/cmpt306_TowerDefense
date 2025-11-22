extends Node2D
class_name Tower

@export var tool_manager: ToolManager


@export var required_tool_index: int

@export var grid_size: Vector2 = Vector2(32, 32)

#@export var tower_sound: AudioStreamPlayer2D  #TODO

@export var min_place_distance: float = 16.0

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if tool_manager == null:
			return
		var current_tool := 3
		
		if not tool_manager.has_method("get_current_tool"):
			return
		if tool_manager.get_current_tool() != required_tool_index:
			current_tool = tool_manager.get_current_tool()
		else:
			return
		
		var towerRes: TowerResource = null
		if tool_manager.has_method("get_selected_tower"):
			towerRes = tool_manager.get_selected_tower()
		else:
			return
		
		if towerRes == null:
			return
		
		#check money
		#if not _can_afford(towerRes.cost):
			#print("Not enough moeny for: ", towerRes.tower_name, " cost:", towerRes.cost)
			#return
			
		var pos = get_global_mouse_position()
		if grid_size.x > 0 and grid_size.y > 0:
			pos = _snap_position(pos)
			
		if _is_too_close(pos):
			print("Cannot place too close to existing tower")
			return
		
		if towerRes.tower_scene == null:
			push_error("TowerResource has no individual scene assigned")
			return
		
		var tower_instance = towerRes.tower_scene.instantiate()
		if tower_instance == null:
			push_error("Failed to instantiated tower scene")
		
		tower_instance.position = pos
		add_child(pos)
		print("Tower placed!")
		
		# deduct money for the cost of building tower
		#_spend_money(towerRes.cost)
		
		
func _is_too_close(pos: Vector2) -> bool:
	for child in get_children():
		if child is Node2D:
			if child.position.distance_to(pos) < min_place_distance:
				return true
	return false
	

func _snap_position(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / grid_size.x) * grid_size.x,
					round(pos.y / grid_size.y) * grid_size.y)
