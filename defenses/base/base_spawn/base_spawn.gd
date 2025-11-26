extends Node2D

@export var base_scene: PackedScene
@export var tool_manager: ToolManager
@export var grid_size: Vector2 = Vector2(32, 32)
@export var min_distance: float = 64.0
@export var max_bases: int = 5
@export var required_tool_index: int
@export var deny_sound: AudioStreamPlayer2D


func _ready() -> void:
	if (required_tool_index == 0 or required_tool_index == -1) and tool_manager:
		required_tool_index = int(tool_manager.tool_enum.Tool.TARGET)
		
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		if get_tree().paused:
			return

		if tool_manager == null:
			return
		if not tool_manager.has_method("get_current_tool"):
			return
		if tool_manager.get_current_tool() != required_tool_index:
			return		
		
		var mouse_pos = get_global_mouse_position()
		if grid_size.x > 0 and grid_size.y > 0:
			mouse_pos = _snap_position(mouse_pos)
		if base_scene == null:
			return
		
		
			
		if _too_close(mouse_pos, min_distance):
			if deny_sound:
				deny_sound.play()
			return
			
		var base_instance = base_scene.instantiate()
		base_instance.global_position = mouse_pos
		get_tree().get_current_scene().add_child(base_instance)
		
func _too_close(pos: Vector2, min_dist: float) -> bool:
	if not get_tree().has_group("TowerBases"):
		return false
	for base in get_tree().get_nodes_in_group("TowerBases"):
		if not is_instance_valid(base):
			continue
		if not (base is Node2D):
			continue
		if base.global_position.distance_to(pos) < min_dist:
			return true
	return false
		
func _snap_position(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / grid_size.x) * grid_size.x,
					round(pos.y / grid_size.y) * grid_size.y)
