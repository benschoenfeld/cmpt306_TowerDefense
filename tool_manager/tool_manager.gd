class_name ToolManager

extends Node2D
## Allows the player to switch tools and interact with tiles.
##
## Updates visuals of [ToolUI], [SeedBag], and mouse.
## Also allows interaction with [BaseTiles] children based upon what tool
## is currently being used.

## Sends out what tool is being selected.
signal tool_changed(tool_index: int)

## Communicates with the [SeedBag] to visually show it or not.
signal request_seed_menu(show_item: bool)

## Communicates with the [TowerBag] to visually show it or not.
signal request_tower_bag(show_item: bool)

## Emits when a tower selection has changed.
signal selected_tower_changed(towerResorce: TowerResource)

## Emits to show a [SimpleToolTip].
signal show_tool_tip(message: String) 

# Cursor constants
const CURSOR_HOTSPOT = Vector2(16, 16)
const CURSOR_SHAPE = Input.CURSOR_ARROW

@export_category("Mouse Icon Textures")

## The asset of the shovel icon for the mouse.
@export var tool_shovel: Texture = preload("res://tool_manager/assets/tool_shovel.png")

## The asset of the watercan icon for the mouse.
@export var tool_waterCan: Texture = preload("res://tool_manager/assets/tool_watering_can.png")

## The asset of the hoe icon for the mouse.
@export var tool_hoe: Texture = preload("res://tool_manager/assets/tool_hoe.png")

## The asset of the target icon for the mouse.
@export var tool_target: Texture = preload("res://tool_manager/assets/target_round_a.png")


@export_category("ToolManager Nodes")
## A reference to an [AudioStreamPlayer] for switching tools action.
@export var switch_sound_player: AudioStreamPlayer

## A reference to an [AudioStreamPlayer] for denying actions.
@export var deny_sound_player: AudioStreamPlayer

@export_category("Game Settings")
## Index of the currrent tools selected
@export var current_tool_index: int = int(tool_enum.Tool.TARGET)

## Reference to the [GameManager]
@export var game_manager: GameManager = null

## Amount of saturation aplied by the tool 'WaterCan'
@export var watering_amount: float = 100.0

## Give the enum for tools that can be shared between scenes.
var tool_enum: ToolEnums = ToolEnums.new()

## Tools array that holds all of the tool [Texture]
var toolArray: Array[Texture] = []

## Currently selected seed resource (set by [SeedBag]; [CropResource] or null)
var selected_seed: CropResource = null

## Currently selected [TowerResource] (set by [TowerBag])
var selected_tower: TowerResource = null

## A reference to a [TileMapLayer] that will be interacted with.
var tile_map: TileMapLayer

## A reference to a model that will be interacted with.
var model: Model

## A [bool] that makes the user not be able to interact with tiles when they
## are not supposed to.
var tool_inactive: bool = true

func _ready() -> void:
	toolArray = [tool_shovel, tool_waterCan, tool_hoe, tool_target]
	current_tool_index = clamp(current_tool_index, 0, toolArray.size() - 1)
	_set_current_tool(current_tool_index)

## A private function that helps [method set_current_tool].
func _set_current_tool(index: int) -> void:
	if toolArray.size() == 0:
		push_error("ToolManager: toolArray empty")
		return
	if index < 0 or index >= toolArray.size():
		push_error("ToolManager: index out of range")
	current_tool_index = index
	var tex = toolArray[current_tool_index]
	if not get_tree().paused:
		if tex:
			Input.set_custom_mouse_cursor(tex, CURSOR_SHAPE, CURSOR_HOTSPOT)
			switch_sound_player.play()
		else:
			Input.set_custom_mouse_cursor(null)
	
	tool_changed.emit(current_tool_index)
	request_seed_menu.emit(current_tool_index == tool_enum.Tool.SHOVEL)
	request_tower_bag.emit(current_tool_index == tool_enum.Tool.TARGET)

## Switches the [param current_tool_index] and switches the mouse icon texture.
func set_current_tool(index: int) -> void:
	_set_current_tool(index)

## Returns the [param current_tool_index].
func get_current_tool() -> int:
	return current_tool_index

## Input handling for scrolling
func _unhandled_input(event: InputEvent) -> void:
	if  get_tree().paused:
		return
	
	if toolArray.size() == 0:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_set_current_tool(( current_tool_index + 1) % toolArray.size())
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_set_current_tool(( current_tool_index - 1 + toolArray.size()) % toolArray.size())

	if (
		event.is_action("interact") and 
		event.is_pressed()
		):
			var canvas_pos: Vector2 = make_canvas_position_local(event.global_position)
			var tile_map_pos: Vector2i = tile_map.local_to_map(canvas_pos)
			var tile: BaseTile = model.get_tile(tile_map_pos)
			if tile:
				interact(tile)

## Handles input of changing the tools.
func _process(_delta: float) -> void:
	
	if get_tree().paused:
		return

	if Input.is_action_just_pressed("equip_shovel"):
		_set_current_tool(int(tool_enum.Tool.SHOVEL))
	if Input.is_action_just_pressed("equip_waterCan"):
		_set_current_tool(int(tool_enum.Tool.WATERCAN))
	if Input.is_action_just_pressed("equip_hoe"):
		_set_current_tool((int(tool_enum.Tool.HOE)))
	if Input.is_action_just_pressed("equip_defenses"):
		_set_current_tool(tool_enum.Tool.TARGET)

## Uses a strategy pattern to interact with a [BaseTile] or extenion.
func interact(tile: BaseTile) -> void:
	if tile == null or tile is Path:
		return

	if tool_inactive and tile is FarmingTile:
		deny_sound_player.play()
		show_tool_tip.emit("Hit the 'Start Wave' button to interact with crops!")
		
		return

	var tool = current_tool_index
	var strategy: ToolBase
	
	match tool:
		int(tool_enum.Tool.HOE):
			strategy = $Hoe
		
		int(tool_enum.Tool.WATERCAN):
			strategy = $Watercan
			var watercan: Watercan = strategy
			watercan.set_watering_amount(watering_amount)
		
		int(tool_enum.Tool.SHOVEL):
			strategy = $Shovel
			var shovel: Shovel = strategy
			shovel.set_seed(selected_seed)
			
		int(tool_enum.Tool.TARGET):
			print("Target Selected")
			strategy = $TowerTool
			var tower_tool: TowerTool = strategy
			tower_tool.set_money_amount(game_manager.get_money())
			tower_tool.set_tower(selected_tower)
			
	strategy.interact_effect(tile)

## Setter for [param tile_map].
func set_tile_map(new_map: TileMapLayer) -> void:
	tile_map = new_map

## Setter for [param model].
func set_model(new_model: Model) -> void:
	model = new_model

## Changes the [param selected_seed] to new CropResource
func _on_seed_bag_selected_seed(seed_selection: CropResource) -> void:
	selected_seed = seed_selection

## A private function that selects a tower.
func _on_tower_bag_selected_tower(towerResorce: TowerResource) -> void:
	selected_tower = towerResorce
	selected_tower_changed.emit(selected_tower)

## A getter function that returns a [param selected_tower].
func get_selected_tower() -> TowerResource:
	return selected_tower

## Sets the [param tool_inactive] true or false.
## Allows player to either use the tools fully or not.
func set_inactive(active: bool) -> void: 
	tool_inactive = active

## A private function that updates the money the [param game_manager] has.
func _on_hoe_money_updated(new_amount: int) -> void:
	if game_manager:
		game_manager.add_money(new_amount)

## A private function that updates the money the [param game_manager] has.
func _on_tower_tool_money_changed(new_amount: int) -> void:
	if game_manager:
		game_manager.add_money(-new_amount)

## A private function that 
func _on_hud_started_wave() -> void:
	set_inactive(false)

## A private function that emits a signal to tell player the cannot place a tower.
func _on_tower_tool_denied_tower() -> void:
	show_tool_tip.emit("Not enough money to place tower!")
