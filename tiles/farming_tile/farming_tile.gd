class_name FarmingTile

extends BaseTile
## The tile that the player interact with their tools.
##
## This is the main tile that the player will use their tools to remove grass,
## water the ground and plant crops.

## The current stats of the tile. Max satuation and visual style.
var current_stats: FarmingTileStats

## [param saturation] determines the type of dirt tile and whether a crop can grow.
var saturation: float = 0.0

## The type of [Crop] that is being planted onto this [FarmingTile].
var current_crop # Make this have a crop scene once that is created.

## A [FarmTileStats] to be used to show grass.
@onready var grass_stats: FarmingTileStats = preload("res://tiles/farming_tile/resources/grass.tres")

## A [FarmTileStats] to be used to show dry dirt.
@onready var dry_dirt_stats: FarmingTileStats = preload("res://tiles/farming_tile/resources/dry_dirt.tres")

## A [FarmTileStats] to be used to show wet dirt.
@onready var wet_dirt_stats: FarmingTileStats = preload("res://tiles/farming_tile/resources/wet_dirt.tres")

## Sets up the tile to the default state.
func _ready() -> void:
	pass

## Sets the tile stats to a new [FarmingTileStats].
func set_tile_stats(new_stats: FarmingTileStats) -> void:
	pass

## Returns a [FarmingTileStats].
func get_tile_stats() -> FarmingTileStats:
	return null

## Sets the current [Crop] scene to the new [Crop] scene.
func set_crop(new_crop) -> void:
	pass

## Returns the current [Crop] scene.
func get_crop():
	pass

## Returns a [bool] based on if there is a crop or not.
func has_crop() -> bool:
	return false

## Sets the [param saturation] amount.
func set_saturation() -> void:
	pass

## Returns the [param saturation] amount.
func get_saturation() -> float:
	return -1.0

## Returns a [bool] whether saturation is more than zero.
func has_saturation() -> bool:
	return false

## Called every frame.
func _process(delta: float) -> void:
	pass

## Lowers the saturation every tick.
func _lower_saturation(delta: float) -> void:
	pass

## Used for interaction with the tile.
func _on_interaction_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
