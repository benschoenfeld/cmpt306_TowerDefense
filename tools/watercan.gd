class_name Watercan

extends ToolBase
##
##
##

##
var watering_amount: float

##
func interact_effect(tile: BaseTile):
	# Use watering can: no effect on grass
	if tile is FarmingTile:
		if tile.get_tile_type() == FarmingTileStats.TileType.GRASS:
			pass
		# apply saturation
		else:
			sound_player.play()
			tile.apply_water(watering_amount)

##
func set_watering_amount(new_amount: float) -> void:
	watering_amount = new_amount
