class_name FarmingTile

extends BaseTile
## The tile that the player interact with their tools.
##
## This is the main tile that the player will use their tools to remove grass,
## water the ground and plant crops.

## The rate of [param saturation] that will be lost every tick.
@export var loss_rate_saturation: float = 0.1

## A [Sprite2D] node that represents the tile type.
@export var tile_sprite: Sprite2D

## A [Sprite2D] node that represents the crop type.
@export var crop_sprite: Sprite2D

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
	current_stats = grass_stats

## Returns a [FarmingTileStats].
func get_tile_stats() -> FarmingTileStats:
	return current_stats

## Sets the tile stats to a new [FarmingTileStats].
func set_tile_stats(new_stats: FarmingTileStats) -> void:
	current_stats = new_stats
	if current_stats:
		tile_sprite.frame = current_stats.tile_type

## Returns the current [Crop] scene.
func get_crop():
	return current_crop

## Sets the current [Crop] scene to the new [Crop] scene.
func set_crop(new_crop) -> void:
	current_crop = new_crop
	# Set the tile to be the crop texture or if there is no crop remove texture
	if new_crop:
		crop_sprite.texture = new_crop.crop_texture
	else:
		crop_sprite.texture = null

## Returns a [bool] based on if there is a crop or not.
func has_crop() -> bool:
	return current_crop != null

## Returns the [param saturation] amount.
func get_saturation() -> float:
	return saturation

## Sets the [param saturation] amount.
func set_saturation(new_saturation: float) -> void:
	saturation = clamp(new_saturation, 0.0, get_tile_stats().get_max_saturation())

## Adds to the [param saturation] amount.
func add_saturation(saturation_addition: float) -> void:
	set_saturation(saturation + saturation_addition)

## Returns a [bool] whether saturation is more than zero.
func has_saturation() -> bool:
	return 0.0 < saturation

## Called every frame.
func _process(delta: float) -> void:
	_lower_saturation(delta)

## Lowers the saturation every tick.
func _lower_saturation(delta: float) -> void:
	# It can only go down if it is a wet dirt tile.
	if current_stats.tile_type == FarmingTileStats.TileType.WET_DIRT:
		# Makes sure that it can only go down to zero.
		if !has_saturation():
			set_saturation(0.0)
			set_tile_stats(dry_dirt_stats)
		else:
			add_saturation(-(loss_rate_saturation * delta))

## Used for interaction with the tile.
func _on_interaction_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		emit_signal("send_tile_data", self)
