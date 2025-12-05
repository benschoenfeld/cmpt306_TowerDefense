class_name CropResource

extends Resource
## Stored infromation about the crops.
##
## Holds visual and game balance data in the script.
## To make a new crop just make a new resource and change values.

## Name of the crop.
@export var crop_name: String

## The amount of time it will take until crop is harvestable.
@export var grow_time: float = 10.0

## Provided spritesheet of all crop stages.
@export var sprite_sheet: Texture2D = preload("res://crops/assets/Crop_Spritesheet.png")

## Determines what frame the sprite starts as.
@export var start_coords: Vector2i = Vector2i(0,0)

## How many frames until full growth.
@export var frames: int = 6

## Money value of the crop when harvested.
@export var value: int

## The grown frame for the UI in the [Seedbag].
@export var icon: Texture2D

## Method to get the value from a crop instantiation. Returns [param value].
func get_value() -> int:
	return value
