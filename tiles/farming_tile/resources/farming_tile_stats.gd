class_name FarmingTileStats

extends Resource
## Allows for different tiles to be made with different stats.

## Shows what type of tile will be visually shown.
enum TileType {GRASS, DRY_DIRT, WET_DIRT}
@export var tile_type: TileType

## The max level of saturation of a given tile.
@export var max_saturation: float

## Returns the [param tile_type] of this tile.
func get_tile_type():
	return tile_type
	
## Returns the [param max_saturation] of this tile.
func get_max_saturation() -> float:
	return max_saturation
