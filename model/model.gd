extends Node

# currently tool_manager is acting as the controller

enum tile_types {
	GRASS,
	DRY_DIRT,
	WET_DIRT,
}

# FarmingTileStats holds farm tile types get_tile_type()
# get tilemaplayer from the gamemanager
@export var farming_tile_map: TileMapLayer

# model dictionary for tracking the state of tiles in game
var tiles:= {} # (Vector2i, FarmingTile)

func get_tile(pos: Vector2i) -> FarmingTile:
	return tiles.get(pos)

func set_tile(pos: Vector2i, tile: FarmingTile) -> void:
	tiles[pos] = tile

func all() -> Dictionary:
	return tiles

# loops through the used cells in the TileMapLayer and adds the tile data to dict
func create_dict() -> Dictionary:
	farming_tile_map.update_internals()
	for position in farming_tile_map.get_used_cells():
		var tile_data = farming_tile_map.get_cell_tile_data(position)
		if tile_data != null:
			tiles[position] = tile_data
	return tiles
