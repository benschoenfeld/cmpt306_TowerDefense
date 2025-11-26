class_name ToolManager

extends Node2D
## Allows the player to switch tools and interact with tiles.
##
## Updates visuals of [ToolUI], [SeedBag], and mouse.
## Also allows interaction with [FarmingTiles] based upon what tool
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

## A reference to an [AudioStreamPlayer] for using the hoe tool.
@export var hoe_sound_player: AudioStreamPlayer

## A reference to an [AudioStreamPlayer] for using the shovel tool.
@export var shovel_sound_player: AudioStreamPlayer

## A reference to an [AudioStreamPlayer] for using the watercan tool.
@export var watercan_sound_player: AudioStreamPlayer

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

var selected_tower: TowerResource = null

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

## Called by [GameManager]'s connect: tile.connect("send_tile_data", Callable(tool_manager, "interact"))
## Accepts a [BaseTile] (or [FarmingTile])  and applies the currently selected tool to it
func interact(tile: BaseTile) -> void:
	if tile == null:
		return
	if not (tile is FarmingTile):
		# ignore
		return
	var farmTile: FarmingTile = tile
	var tool = current_tool_index
	match tool:
		int(tool_enum.Tool.HOE):
			# Use 'Hoe': till grass -> dry dirt; harvest if ripe
			if farmTile.get_tile_type() == FarmingTileStats.TileType.GRASS:
				hoe_sound_player.play()
				farmTile.set_tile_stats(farmTile.dry_dirt_stats)
				farmTile.set_saturation(0.0)
				return
			# if tile has grown crop: harvest
			if farmTile.has_crop():
				var harvested: CropResource = farmTile.harvest_crop()
				if harvested != null and game_manager != null:
					$HoeSound.play()
					# award money
					game_manager.add_money(harvested.get_value())
				return
		
		int(tool_enum.Tool.WATERCAN):
			# Use watering can: no effect on grass
			if farmTile.get_tile_type() == FarmingTileStats.TileType.GRASS:
				return
			# apply saturation
			if farmTile.has_method("apply_water"):
				watercan_sound_player.play()
				farmTile.apply_water(watering_amount)
			else:
				watercan_sound_player.play()
				farmTile.add_saturation(watering_amount)
				if farmTile.has_saturation() and farmTile.get_tile_type() == FarmingTileStats.TileType.DRY_DIRT:
					farmTile.set_tile_stats(farmTile.wet_dirt_stats)
		
		int(tool_enum.Tool.SHOVEL):
			# Shovel opens seed menu ( if no seed selected) otherwise plant if valid
			# if there is a selected seed, plant it into dry/wet dirt
			
			if selected_seed != null:
				if farmTile.get_tile_type() == FarmingTileStats.TileType.DRY_DIRT or farmTile.get_tile_type() == FarmingTileStats.TileType.WET_DIRT:
					$ShovelSound.play()
					farmTile.set_crop(selected_seed)
					return
		


## Changes the [param selected_seed] to new CropResource
func _on_seed_bag_selected_seed(seed_selection: CropResource) -> void:
	selected_seed = seed_selection
	
func _on_tower_bag_selected_tower(towerResorce: TowerResource) -> void:
	selected_tower = towerResorce
	emit_signal("selected_tower_changed", selected_tower)


func get_selected_tower() -> TowerResource:
	return selected_tower
