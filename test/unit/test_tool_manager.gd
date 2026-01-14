extends GutTest

var tool_manager_scene: PackedScene = preload("res://tool_manager/tool_manager.tscn")
var tool_manager: ToolManager

func before_each():
	tool_manager = tool_manager_scene.instantiate()
	add_child_autofree(tool_manager)

func test_set_current_tool():
	tool_manager.set_current_tool(ToolEnums.Tool.SHOVEL)
	assert_eq(tool_manager.current_tool_index, ToolEnums.Tool.SHOVEL)
	
	tool_manager.set_current_tool(ToolEnums.Tool.WATERCAN)
	assert_eq(tool_manager.current_tool_index, ToolEnums.Tool.WATERCAN)
	
	tool_manager.set_current_tool(ToolEnums.Tool.HOE)
	assert_eq(tool_manager.current_tool_index, ToolEnums.Tool.HOE)
	
	tool_manager.set_current_tool(ToolEnums.Tool.TARGET)
	assert_eq(tool_manager.current_tool_index, ToolEnums.Tool.TARGET)

func test_get_current_tool():
	tool_manager.set_current_tool(ToolEnums.Tool.SHOVEL)
	assert_eq(tool_manager.get_current_tool(), ToolEnums.Tool.SHOVEL)
	
	tool_manager.set_current_tool(ToolEnums.Tool.WATERCAN)
	assert_eq(tool_manager.get_current_tool(), ToolEnums.Tool.WATERCAN)
	
	tool_manager.set_current_tool(ToolEnums.Tool.HOE)
	assert_eq(tool_manager.get_current_tool(), ToolEnums.Tool.HOE)
	
	tool_manager.set_current_tool(ToolEnums.Tool.TARGET)
	assert_eq(tool_manager.get_current_tool(), ToolEnums.Tool.TARGET)

func test_interact():
	var base_tile: BaseTile = preload("res://tiles/base_tile/base_tile.tscn").instantiate()
	var path_tile: Path = preload("res://path/path.tscn").instantiate()
	var farming_tile: FarmingTile = preload("res://tiles/farming_tile/farming_tile.tscn").instantiate()
	var game_manager: GameManager = preload("res://game_manager/game_manager.tscn").instantiate()
	add_child_autofree(base_tile)
	add_child_autofree(path_tile)
	add_child_autofree(farming_tile)
	add_child_autofree(game_manager)
	tool_manager.game_manager = game_manager
	
	# Should do nothing.
	tool_manager.interact(null)
	
	# Should do nothing due to non-interact flag.
	tool_manager.interact(farming_tile)
	
	tool_manager.set_inactive(false)
	
	# Should do nothing due to base tile.
	tool_manager.interact(base_tile)
	
	# Should do nothing due to path tile.
	tool_manager.interact(path_tile)
	
	# Should do nothing to farming tile
	tool_manager.set_current_tool(ToolEnums.Tool.SHOVEL)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.GRASS)
	
	tool_manager.set_current_tool(ToolEnums.Tool.WATERCAN)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.GRASS)
	
	# Should set GRASS to DRY_DIRT
	tool_manager.set_current_tool(ToolEnums.Tool.HOE)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.DRY_DIRT)
	
	# Should do nothing
	tool_manager.set_current_tool(ToolEnums.Tool.HOE)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.DRY_DIRT)
	
	tool_manager.set_current_tool(ToolEnums.Tool.SHOVEL)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.DRY_DIRT)

	# Adds saturation
	tool_manager.set_current_tool(ToolEnums.Tool.WATERCAN)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.WET_DIRT)
	
	# Planting crop
	tool_manager.set_current_tool(ToolEnums.Tool.SHOVEL)
	var seed_resource: CropResource = preload("res://crops/resources/eggplant.tres")
	tool_manager.selected_seed = seed_resource
	farming_tile.set_crop(seed_resource)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_crop().get_crop_resource(), seed_resource)
	
	# Collect the crop
	farming_tile.get_crop().is_grown = true
	tool_manager.set_current_tool(int(ToolEnums.Tool.HOE))
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_crop(), null)

func test_get_selected_tower():
	assert_eq(tool_manager.get_selected_tower(), null)
	
	var tower_resource: TowerResource = TowerResource.new()
	tool_manager.selected_tower = tower_resource
	assert_eq(tool_manager.get_selected_tower(), tower_resource)

func test_set_inactive():
	tool_manager.set_inactive(false)
	assert_eq(tool_manager.tool_inactive, false)
	
	tool_manager.set_inactive(true)
	assert_eq(tool_manager.tool_inactive, true)

func test_set_tile_map():
	var tile_map: TileMapLayer = TileMapLayer.new()
	tool_manager.set_tile_map(tile_map)
	assert_eq(tool_manager.tile_map, tile_map)
	
	tile_map.free()

func test_set_model():
	var model: Model = Model.new()
	tool_manager.set_model(model)
	assert_eq(tool_manager.model, model)
