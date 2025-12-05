class_name Tower

extends Node2D
## Handles placement of towers using player tools.
##
## The [Tower] node is responsible for detecting player input, checking
## the selected tool, validating build positions, verifying resources,
## and spawning [TowerInstance] scenes on valid [BuildBase] tiles.
##
## It works with [ToolManager] and [GameManager].

## Reference to [ToolManager] that controls tool selection.
@export var tool_manager: ToolManager

## Reference to [GameManager] that tracks game state.
@export var game_manager: GameManager

## Packed scene for building a new [TowerInstance].
@export var tower_instance: PackedScene

## The tool index required to place tower.
@export var required_tool_index: int

## The snap grid size for aligning towers when placed.
@export var grid_size: Vector2 = Vector2(32, 32)

## The distance allowed when searching for a buildable base.
@export var min_distance: float = 64.0

## Sound played when the player attempts to place a tower but cannot.
@export var deny_sound: AudioStreamPlayer2D   #TODO

## Initializes tower controller.
func _ready() -> void:
	if (required_tool_index == 0 or required_tool_index == -1) and tool_manager:
		required_tool_index = int(tool_manager.tool_enum.Tool.TARGET)

## Handles input for tower placement.
##
## Confirms correct tool is selected on LEFT MOUSE CLICK
## Checks money_amount, and does all tower placement logic.
##
## @paaram event Input events (LEFT MOUSE CLICK)
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
		
		# Gets selected tower resource
		var towerRes: TowerResource = null
		if tool_manager.has_method("get_selected_tower"):
			towerRes = tool_manager.get_selected_tower()
		else:
			return
		
		if towerRes == null:
			return
		
		# Check money
		if not _can_afford_a_tower(towerRes.cost):
			if deny_sound:
				deny_sound.play()
			print("Not enough moeny for: ", towerRes.tower_name, " cost:", towerRes.cost)
			return
		
		# Position snapping
		var mouse_pos = get_global_mouse_position()
		if grid_size.x > 0 and grid_size.y > 0:
			mouse_pos = _snap_position(mouse_pos)
		
		# Check valid build base
		var base = build_base(mouse_pos, min_distance)
		if base == null:
			print("No build base found udner cursor")
			return
		
		# Set tower scene
		if tower_instance == null:
			push_error("Tower: No tower instance assigned in Inspector")
			return
		
		var towerInstance = tower_instance.instantiate()
		if towerInstance == null:
			push_error("Failed to instantiated tower scene")
			return
		
		# Place tower
		towerInstance.position = base.global_position
		get_tree().get_current_scene().add_child(towerInstance)
		
		# Apply tower resource
		if towerInstance.has_method("apply_tower_resource"):
			towerInstance.apply_tower_resource(towerRes)
		else:
			print("TowerInstance has no apply_tower_resource method -> Incorrect assigned?")
		print("Tower placed at ", mouse_pos)
		
		# Set base as occupied
		base.set_meta("occupied", true)
		base.set_meta("occupier_path", towerInstance.get_path())
		towerInstance.set_meta("base_node_path", base.get_path())
		
		# Check tower is in correct group
		if not towerInstance.is_in_group("Towers"):
			towerInstance.add_to_group("Towers")
			
		# Deduct money for the cost of building tower
		_buy_tower(towerRes.cost)

## Searches all [BuildBase] nodes and returns the nearest available one.
##
## @param pos The position being checked.
## @param max_dist Maximum distance allowed to select a base.
## @return The closest [BuildBase] or null.
func build_base(pos: Vector2, max_dist: float) -> Node2D:
	var new_base: Node2D = null
	var distanceToBase = max_dist
	
	# Get bases
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

## Snaps a position to the grid.
##
## @param pos The position in the game
## @return A grid position converted from the game
func _snap_position(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / grid_size.x) * grid_size.x,
					round(pos.y / grid_size.y) * grid_size.y)

## Checks if the player has sufficient money to place a tower.
##
## @param cost The cost of the tower.
## @return True if the player can afford tower.
func _can_afford_a_tower(cost: int) -> bool:
	if game_manager and game_manager.has_method("get_money"):
		return game_manager.get_money() >= cost
	return true

## Deducts cost of building a tower from the player money.
##
## @ param cost The cost of the tower.
func _buy_tower(cost: int) -> void:
	if game_manager and game_manager.has_method("add_money"):
		game_manager.add_money(-cost)
		return

## Placeholder for when the tower resource changes in ToolManager.
##
## @param towerResource The new selected tower resource.
func _on_tool_manager_selected_tower_changed(towerResorce: TowerResource) -> void:
	pass # Replace with function body.
