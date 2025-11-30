class_name Shovel

extends ToolBase
##
##
##

##
var selected_seed: CropResource

##
func interact_effect(tile: BaseTile):
	# Shovel opens seed menu (if no seed selected) otherwise plant if valid
	# if there is a selected seed, plant it into dry/wet dirt
	if tile is FarmingTile:
		if selected_seed != null:
			if  (tile.get_tile_type() == FarmingTileStats.TileType.DRY_DIRT or 
				tile.get_tile_type() == FarmingTileStats.TileType.WET_DIRT):
					sound_player.play()
					tile.set_crop(selected_seed)

## 
func set_seed(new_seed: CropResource):
	selected_seed = new_seed
