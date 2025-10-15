extends Resource
class_name CropResource

# Name of the crop
@export var crop_name: String

# Time it takes until crop is harvestable
@export var grow_time: float = 10.0

# Provided spritesheet of all crop stages
@export var sprite_sheet: Texture2D

# Determines what frame the sprite starts as
@export var start_coords: Vector2i = Vector2i(0,0)

# How many frames until full growth
@export var frames: int = 6

# Value of the crop
@export var value: int

## Method to get the value from a crop instantiation
func get_value() -> int:
	return value
