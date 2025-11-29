class_name Model

extends Node

# currently tool_manager is acting as the controller

enum tile_types {
	GRASS,
	DRY_DIRT,
	WET_DIRT,
}

# model dictionary for tracking the state of tiles in game
var tiles:= {} # (Vector2i, FarmingTile)

func get_tile(pos: Vector2i) -> FarmingTile:
	return tiles.get(pos)

func set_tile(pos: Vector2i, tile: FarmingTile) -> void:
	tiles[pos] = tile

func all() -> Dictionary:
	return tiles

func test_model(pos: Vector2i):
	if tiles.has(pos):
		print(tiles[pos])

# loops through the used cells in the TileMapLayer and adds the tile data to dict
func create_dict(tile_map: TileMapLayer) -> Dictionary:
	tile_map.update_internals()
	for tile in tile_map.get_children():
		var tile_position = tile.position / 32
		if tile_position != null:
			tiles[Vector2i(tile_position.x-0.5, tile_position.y-0.5)] = tile
	print(tiles)
	return tiles
