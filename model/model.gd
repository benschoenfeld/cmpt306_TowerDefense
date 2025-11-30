class_name Model

extends RefCounted
## The data model that holds the game tiles.
##
## Holds tiles such as [FarmingTile] and [BuildBase].

## Size of the tilemaps cells.
const TILE_SIZE = 32

## Positioning offset for the tiles.
const OFFSET = 0.5

## Holds the grid data within a [Dictionary]. 
## Has [Vector2i] as a key and [Node2D] as a value.
var tiles: Dictionary[Vector2i, Node2D]

## Returns a tile scene reference or null.
func get_tile(pos: Vector2i) -> Node2D:
	return tiles.get(pos)

## Sets a tile in the dictionary based on position.
func add_tile(pos: Vector2i, tile: Node2D) -> void:
	tiles[pos] = tile

## Sets a tile in the dictionary based on position.
## Returns true if the tile was set and false if it was not changed
func set_tile(pos: Vector2i, tile: Node2D) -> bool:
	if tiles.has(pos):
		tiles[pos] = tile
		return true
	
	return false

## Returns the [param tiles].
func get_all() -> Dictionary:
	return tiles

## Loops through the children in a [TileMapLayer] and adds the tile data
## to the [param tiles] dictionary with the position as a key.
func create_dict(tile_map: TileMapLayer) -> void:
	for tile in tile_map.get_children():
		var tile_position = tile.position / TILE_SIZE
		if tile_position != null:
			tiles[Vector2i(tile_position.x-OFFSET, tile_position.y-OFFSET)] = tile
