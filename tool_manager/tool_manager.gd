class_name ToolManager
extends Node2D

signal tool_changed(tool_index: int)
signal request_seed_menu(show_item: bool)

# Cursor constants
const CURSOR_HOTSPOT = Vector2(16, 16)
const CURSOR_SHAPE = Input.CURSOR_ARROW

@export_category("Enums")
## Give the enum for tools that can be shared between scenes.
@export var tool_enum: ToolEnums

@export_category("Mouse Icon Textures")
@export var tool_shovel = preload("res://tool_manager/assets/tool_shovel.png")
@export var tool_waterCan = preload("res://tool_manager/assets/tool_watering_can.png")
@export var tool_hoe = preload("res://tool_manager/assets/tool_hoe.png")

@export_category("ToolManager Nodes")
@export var switch_sound_player: AudioStreamPlayer
@export var hoe_sound_player: AudioStreamPlayer
@export var shovel_sound_player: AudioStreamPlayer
@export var watercan_sound_player: AudioStreamPlayer

@export_category("Game Settings")
# Index of the currrent tools selected
@export var current_tool_index: int = int(tool_enum.Tool.SHOVEL)

# Reference to GameManager
@export var game_manager: Node = null

# Amount of saturation aplied by the tool 'WaterCan'
@export var watering_amount: float = 100.0

# Tools array
var toolArray: Array = []

# Currently seletec seed resource (set by seed menu; CropResource or null)
var selected_seed: CropResource = null

func _ready() -> void:
	toolArray = [tool_shovel, tool_waterCan, tool_hoe]
	current_tool_index = clamp(current_tool_index, 0, toolArray.size() - 1)
	_set_current_tool(current_tool_index)
	

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

func set_current_tool(index: int) -> void:
	_set_current_tool(index)

func get_current_tool() -> int:
	return current_tool_index


# Input handling for scrolling
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
			
func _process(_delta: float) -> void:
	
	if get_tree().paused:
		return

	if Input.is_action_just_pressed("equip_shovel"):
		_set_current_tool(int(tool_enum.Tool.SHOVEL))
	if Input.is_action_just_pressed("equip_waterCan"):
		_set_current_tool(int(tool_enum.Tool.WATERCAN))
	if Input.is_action_just_pressed("equip_hoe"):
		set_current_tool((int(tool_enum.Tool.HOE)))

# Called by GameManager's connect: tile.connect("send_tile_data", Callable(tool_manager, "interact"))
# Accepts a BaseTile (or FarmingTile)  and applies the currently selected tool to it
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
				# TODO: Set the sound for grass to be removed
				# hoe_sound_player.stream = grass sound
				hoe_sound_player.play()
				farmTile.set_tile_stats(farmTile.dry_dirt_stats)
				farmTile.set_saturation(0.0)
				return
			# if tile has grown crop: harvest
			if farmTile.has_crop():
				var harvested: CropResource = farmTile.harvest_crop()
				if harvested != null and game_manager != null:
					# TODO: Set the sound for crop to be removed
					# hoe_sound_player.stream = crop havest sound
					hoe_sound_player.play()
					# award money
					game_manager.add_money(harvested.get_value())
				return
		
		int(tool_enum.Tool.WATERCAN):
			# Use watering can: no effect on grass
			if farmTile.get_tile_type() == FarmingTileStats.TileType.GRASS:
				return
			# apply saturation
			if farmTile.has_method("apply_water"):
				farmTile.apply_water(watering_amount)
			else:
				# TODO: Set the sound for ground to be wated
				# watercan_sound_player.stream = water sound
				watercan_sound_player.play()
				farmTile.add_saturation(watering_amount)
				if farmTile.has_saturation() and farmTile.get_tile_type() == FarmingTileStats.TileType.DRY_DIRT:
					farmTile.set_tile_stats(farmTile.wet_dirt_stats)
		
		int(tool_enum.Tool.SHOVEL):
			# Shovel opens seed menu ( if no seed selected) otherwise plant if valid
			# if there is a selected seed, plant it into dry/wet dirt
			
			if selected_seed != null:
				if farmTile.get_tile_type() == FarmingTileStats.TileType.DRY_DIRT or farmTile.get_tile_type() == FarmingTileStats.TileType.WET_DIRT:
					# TODO: Set the sound for crop to be planted
					# shovel_sound_player.stream = crop planted sound
					shovel_sound_player.play()
					farmTile.set_crop(selected_seed)
					return

## Changes the [param selected_seed] to new CropResource
func _on_seed_bag_selected_seed(seed_selection: CropResource) -> void:
	selected_seed = seed_selection
