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
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
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
			
		var mouse_pos = get_global_mouse_position()
		if grid_size.x > 0 and grid_size.y > 0:
			mouse_pos = _snap_position(mouse_pos)
			
		var base = build_base(mouse_pos, min_distance)
		if base == null:
			print("No build base found udner cursor")
			return

		if towerRes.tower_scene == null:
			push_error("TowerResource has no individual scene assigned")
			return
		
		var tower_instance = towerRes.tower_scene.instantiate()
		if tower_instance == null:
			push_error("Failed to instantiated tower scene")
			return
		
		tower_instance.position = base.global_position
		get_tree().get_current_scene().add_child(tower_instance)
		print("Tower placed at ", mouse_pos)
		
		base.set_meta("occupied", true)
		base.set_meta("occupier_path", tower_instance.get_path())
		tower_instance.set_meta("base_node_path", base.get_path())
		
		if not tower_instance.is_in_group("Towers"):
			tower_instance.add_to_group("Towers")
		# deduct money for the cost of building tower
		_buy_tower(towerRes.cost)
		
		if tower_sound:
			tower_sound.play()
		

func build_base(pos: Vector2, max_dist: float) -> Node2D:
	var new_base: Node2D = null
	var distanceToBase = max_dist
	for base in get_tree().get_nodes_in_group("TowerBases"):
		if not is_instance_valid(base):
			continue
		var dist = base.global_position.distance_to(pos)
		if dist <= distanceToBase:
			distanceToBase = dist
			new_base = base
	if new_base and new_base.get_meta("occupied", false):
		return null
	return new_base
	
	
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
		

		


func _on_tool_manager_selected_tower_changed(towerResorce: TowerResource) -> void:
	pass # Replace with function body.
