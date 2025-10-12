extends Node2D

@export var crop_data: CropResource
@onready var sprite: Sprite2D = $Sprite2D

var stage: int = 0
var time_passed: float = 0.0
var soil_tile # reference to soil tile
var is_grown: bool = false

#var crop_instance = preload("res://Crop.tscn").instantiate()
#crop_instance.crop_data = preload("res://crops/tomato.tres")
#crop_instance.soil_tile = self
#add_child(crop_instance)

func _ready() -> void:
	if crop_data == null:
		return
		
	sprite.texture = crop_data.sprite_sheet
	
func _process(delta: float):
	if crop_data == null:
		return
	
	if soil_tile != null and soil_tile.is_saturated():
		return
		
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

func _update_sprite():
	var row = crop_data.start_coords.y
	var col = crop_data.start_coords.x - stage	# step left from fully grown
	var frame_index = row * sprite.hframes + col
	sprite.frame = frame_index
