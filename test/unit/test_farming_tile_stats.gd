extends GutTest

var farming_tile_stats: FarmingTileStats

func before_each():
	farming_tile_stats = FarmingTileStats.new()

func test_get_tile_type():
	for type: FarmingTileStats.TileType in [farming_tile_stats.TileType.GRASS, 
										farming_tile_stats.TileType.DRY_DIRT, 
										farming_tile_stats.TileType.WET_DIRT]:
		farming_tile_stats.tile_type = type
		assert_eq(farming_tile_stats.get_tile_type(), type)

func test_get_max_saturation():
	farming_tile_stats.max_saturation = 10.0
	assert_eq(farming_tile_stats.get_max_saturation(), 10.0)
