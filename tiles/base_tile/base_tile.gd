class_name BaseTile

extends Node2D
## The base tile for all other tiles to be built off of.
##
## Allow for changes to impact all tiles if tile systems change.

## Allows for other nodes to obtain data 
signal send_tile_data(tile_data: BaseTile)
