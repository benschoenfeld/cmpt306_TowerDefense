extends GutTest

var tool_manager_scene: PackedScene = preload("res://tool_manager/tool_manager.tscn")
var tool_manager: ToolManager

func before_each():
	tool_manager = tool_manager_scene.instantiate()
	add_child_autofree(tool_manager)

func test_set_current_tool():
	tool_manager.set_current_tool(0)
	assert_eq(tool_manager.current_tool_index, 0)
	
	tool_manager.set_current_tool(1)
	assert_eq(tool_manager.current_tool_index, 1)
	
	tool_manager.set_current_tool(2)
	assert_eq(tool_manager.current_tool_index, 2)

func test_get_current_tool():
	tool_manager.set_current_tool(0)
	assert_eq(tool_manager.get_current_tool(), 0)
	
	tool_manager.set_current_tool(1)
	assert_eq(tool_manager.get_current_tool(), 1)
	
	tool_manager.set_current_tool(2)
	assert_eq(tool_manager.get_current_tool(), 2)

func test_interact():
	var base_tile: BaseTile = preload("res://tiles/base_tile/base_tile.tscn").instantiate()
	var farming_tile: FarmingTile = preload("res://tiles/farming_tile/farming_tile.tscn").instantiate()
	add_child_autofree(base_tile)
	add_child_autofree(farming_tile)
	# Should do nothing.
	tool_manager.interact(null)
	
	# Should do nothing.
	tool_manager.interact(base_tile)
	
	# Should do nothing to farming tile
	tool_manager.set_current_tool(0)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.GRASS)
	
	tool_manager.set_current_tool(1)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.GRASS)
	
	# Should set GRASS to DRY_DIRT
	tool_manager.set_current_tool(2)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.DRY_DIRT)
	
	# Should do nothing
	tool_manager.set_current_tool(2)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.DRY_DIRT)
	
	tool_manager.set_current_tool(0)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.DRY_DIRT)

	# Adds saturation
	tool_manager.set_current_tool(1)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_tile_type(), FarmingTileStats.TileType.WET_DIRT)
	
	# Planting crop
	tool_manager.set_current_tool(0)
	var seed_resource: CropResource = preload("res://crops/resources/eggplant.tres")
	tool_manager.selected_seed = seed_resource
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_crop().get_crop_resource(), seed_resource)
	
	# Collect the crop
	farming_tile.get_crop().is_grown = true
	tool_manager.set_current_tool(2)
	tool_manager.interact(farming_tile)
	assert_eq(farming_tile.get_crop(), null)
	
