extends Node2D
class_name Tower

@export var tool_manager: ToolManager

@export var game_manager: GameManager

@export var required_tool_index: int

@export var grid_size: Vector2 = Vector2(32, 32)

@export var min_distance: float = 64.0

@export var tower_sound: AudioStreamPlayer2D  #TODO
@export var deny_sound: AudioStreamPlayer2D   #TODO


func _ready() -> void:
	if (required_tool_index == 0 or required_tool_index == -1) and tool_manager:
		required_tool_index = int(tool_manager.tool_enum.Tool.TARGET)

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused:
		return
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		if tool_manager == null:
			return
		if not tool_manager.has_method("get_current_tool"):
			return
		if tool_manager.get_current_tool() != required_tool_index:
			return
		
		
		var towerRes: TowerResource = null
		if tool_manager.has_method("get_selected_tower"):
			towerRes = tool_manager.get_selected_tower()
		else:
			return
		
		if towerRes == null:
			return
		
		#check money
		if not _can_afford_a_tower(towerRes.cost):
			if deny_sound:
				deny_sound.play()
			print("Not enough moeny for: ", towerRes.tower_name, " cost:", towerRes.cost)
			return
			
		var pos = get_global_mouse_position()
		if grid_size.x > 0 and grid_size.y > 0:
			pos = _snap_position(pos)
			
		if _is_too_close(pos):
			if deny_sound:
				deny_sound.play()
			print("Tower cannot be placed too close to another tower")
			return
			
		if towerRes.tower_scene == null:
			push_error("TowerResource has no individual scene assigned")
			return
		
		var tower_instance = towerRes.tower_scene.instantiate()
		if tower_instance == null:
			push_error("Failed to instantiated tower scene")
			return
		
		tower_instance.position = pos
		add_child(tower_instance)
		print("Tower placed at ", pos)
		
		if not tower_instance.is_in_group("Towers"):
			tower_instance.add_to_group("Towers")
		# deduct money for the cost of building tower
		_buy_tower(towerRes.cost)
		
		if tower_sound:
			tower_sound.play()
		
		

	

func _snap_position(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / grid_size.x) * grid_size.x,
					round(pos.y / grid_size.y) * grid_size.y)
					
func _can_afford_a_tower(cost: int) -> bool:
	if game_manager and game_manager.has_method("get_money"):
		return game_manager.get_money() >= cost
	return true

func _buy_tower(cost: int) -> void:
	if game_manager and game_manager.has_method("add_money"):
		game_manager.add_money(-cost)
		return
		
func _is_too_close(pos: Vector2) -> bool:
	for node in get_tree().get_nodes_in_group("Towers"):
		if node is Node2D:
			if node.position.distance_to(pos) < min_distance:
				return true
	return false
		


func _on_tool_manager_selected_tower_changed(towerResorce: TowerResource) -> void:
	pass # Replace with function body.
