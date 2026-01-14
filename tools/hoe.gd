class_name Hoe

extends ToolBase
## Part of a strategy pattern with the [ToolManager].
##
## Interacts with a [FarmingTile] and either changes the tile stats
## or harvests the crop.

## Emits when the player has received money. Helps update UI.
signal money_updated(new_amount: int)

## Either changes a [enum FarmingTileStats.TileType.GRASS] into an 
## [enum FarmingTileStats.TileType.DRY_DIRT] or havests a crop from a 
## [FarmingTile].
func interact_effect(tile: BaseTile):
	if tile is FarmingTile:
		if tile.get_tile_type() == FarmingTileStats.TileType.GRASS:
			sound_player.play()
			tile.set_tile_stats(tile.dry_dirt_stats)
			tile.set_saturation(0.0)
		else:
			var harvested: CropResource = tile.harvest_crop()
			if harvested != null:
				sound_player.play()
				# award money
				money_updated.emit(harvested.get_value())
