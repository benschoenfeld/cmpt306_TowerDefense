class_name Shovel

extends ToolBase
## Part of a strategy pattern with the [ToolManager].
##
## Interacts with a [FarmingTile] and plants a crop to a tile.

## The current [CropResource] that will be planted into a [Crop].
var selected_seed: CropResource

## Plants a [CropResource] into a [FarmingTile] with a [Crop].
func interact_effect(tile: BaseTile):
	# Shovel opens seed menu (if no seed selected) otherwise plant if valid
	# if there is a selected seed, plant it into dry/wet dirt
	if tile is FarmingTile:
		if selected_seed != null:
			if  (tile.get_tile_type() == FarmingTileStats.TileType.DRY_DIRT or 
				tile.get_tile_type() == FarmingTileStats.TileType.WET_DIRT):
					sound_player.play()
					tile.set_crop(selected_seed)

## Sets the [param selected_seed] with a new [CropResource].
func set_seed(new_seed: CropResource):
	selected_seed = new_seed
