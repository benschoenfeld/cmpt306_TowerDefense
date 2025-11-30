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
signal selected_tower_changed(towerResorce: TowerResource)

# Cursor constants
const CURSOR_HOTSPOT = Vector2(16, 16)
const CURSOR_SHAPE = Input.CURSOR_ARROW

@export_category("Enums")
## Give the enum for tools that can be shared between scenes.
@export var tool_enum: ToolEnums

@export_category("Mouse Icon Textures")

## The asset of the shovel icon for the mouse.
@export var tool_shovel: Texture = preload("res://tool_manager/assets/tool_shovel.png")

## The asset of the watercan icon for the mouse.
@export var tool_waterCan: Texture = preload("res://tool_manager/assets/tool_watering_can.png")

## The asset of the hoe icon for the mouse.
@export var tool_hoe: Texture = preload("res://tool_manager/assets/tool_hoe.png")

## The asset of the target icon for the mouse.
@export var tool_target = preload("res://tool_manager/assets/target_round_a.png")


@export_category("ToolManager Nodes")
## A reference to an [AudioStreamPlayer] for switching tools action.
@export var switch_sound_player: AudioStreamPlayer

@export_category("Game Settings")
## Index of the currrent tools selected
@export var current_tool_index: int = int(tool_enum.Tool.SHOVEL)

## Reference to the [GameManager]
@export var game_manager: GameManager = null

## Amount of saturation aplied by the tool 'WaterCan'
@export var watering_amount: float = 100.0

## Tools array that holds all of the tool [Texture]
var toolArray: Array[Texture] = []

## Currently selected seed resource (set by seed menu; CropResource or null)
var selected_seed: CropResource = null

##
var selected_tower: TowerResource = null

## A reference to a [TileMapLayer] that will be interacted with.
var tile_map: TileMapLayer

## A reference to a model that will be interacted with.
var model: Model

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

## 
func interact(tile: BaseTile) -> void:
	if tile == null:
		return
	if not (tile is FarmingTile):
		# ignore
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

##
func _on_tower_bag_selected_tower(towerResorce: TowerResource) -> void:
	selected_tower = towerResorce
	emit_signal("selected_tower_changed", selected_tower)

##
func get_selected_tower() -> TowerResource:
	return selected_tower


func _on_hoe_money_updated(new_amount: int) -> void:
	game_manager.add_money(new_amount)
