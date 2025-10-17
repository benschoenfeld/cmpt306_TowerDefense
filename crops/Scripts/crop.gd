class_name Crop

extends Node2D
## Displays the [CropResource] both visually in growth and with audio.

@export var crop_data: CropResource
@export var grow_sound: AudioStream

@onready var sprite: Sprite2D = $Sprite2D
@onready var audio: AudioStreamPlayer2D = $GrowSound

var stage: int = 0
var time_passed: float = 0.0
var soil_tile # reference to soil tile
var is_grown: bool = false

func _ready() -> void:
	# Ensure a crop exists
	if crop_data == null:
		return
	
	# set the sprites texture to its respective coordinates on spritesheet
	sprite.texture = crop_data.sprite_sheet
	
	# Play the growth sound on planting
	if grow_sound != null:
		audio.stream = grow_sound
	audio.play()
	
func _process(delta: float):
	# Ensure a crop exists
	if crop_data == null:
		return
	
	# Only proceed with growth if the tile exists and is saturated
	if soil_tile != null and !soil_tile.is_saturated():
		return
		
	# Stop updating when the crop is fully grown
	if is_grown:
		return
	
	time_passed += delta
	var stage_duration = crop_data.grow_time / crop_data.frames
	var new_stage = int(time_passed / stage_duration)
	if new_stage != stage and new_stage < crop_data.frames:
		stage = new_stage
		_update_sprite()
		
		# check if fully grown
	if stage >= crop_data.frames - 1:
		is_grown = true
		print("Crop is ready to harvest.")

## Set the [param crop_data] to a new [CropResource].
func set_crop_resource(new_crop: CropResource) -> void:
	crop_data = new_crop

## Returns the current [CropResource].
func get_crop_resource() -> CropResource:
	return crop_data

## Update the sprite to proceed to next growth stage
## Each crop starts on a specific row and has 6 contiguous frames
## Must go backward from seed stage (last frame of sequence)
func _update_sprite():
	var row = crop_data.start_coords.y
	var col = crop_data.start_coords.x - stage	# step left from fully grown
	var frame_index = row * sprite.hframes + col
	sprite.frame = frame_index
	
	# Play a growth sound on every frame switch
	if grow_sound != null:
		audio.stream = grow_sound
	audio.play()
