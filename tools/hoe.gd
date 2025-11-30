class_name Hoe

extends ToolBase
##
##
##

##
signal money_updated(new_amount: int)

##
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
