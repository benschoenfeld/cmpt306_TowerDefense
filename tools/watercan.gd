class_name Watercan

extends ToolBase
## Part of a strategy pattern with the [ToolManager].
##
## Interacts with a [BuildBase] and a [TowerResource] in it.

## A [float] that will be added to [member FarmingTile.saturation].
var watering_amount: float

## Adds [param watering_amount] to [member FarmingTile.saturation].
func interact_effect(tile: BaseTile):
	# Use watering can: no effect on grass
	if tile is FarmingTile:
		if tile.get_tile_type() == FarmingTileStats.TileType.GRASS:
			pass
		# apply saturation
		else:
			sound_player.play()
			tile.apply_water(watering_amount)

## A setter for the [param watering_amount].
func set_watering_amount(new_amount: float) -> void:
	watering_amount = new_amount
