class_name Hoe

extends ToolBase
##
##
##

##
var game_manager: GameManager

##
func interact_effect(tile: BaseTile):
	if tile is FarmingTile:
		if tile.get_tile_type() == FarmingTileStats.TileType.GRASS:
			sound_player.play()
			tile.set_tile_stats(tile.dry_dirt_stats)
			tile.set_saturation(0.0)
		else:
			var harvested: CropResource = tile.harvest_crop()
			if harvested != null and game_manager != null:
				sound_player.play()
				# award money
				game_manager.add_money(harvested.get_value())

##
func set_game_manager(new_game_manager: GameManager):
	game_manager = new_game_manager
