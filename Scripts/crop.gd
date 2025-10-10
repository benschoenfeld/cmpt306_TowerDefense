extends Node2D

@export var crop_data: CropResource
@onready var sprite: Sprite2D = $Sprite2D

var stage: int = 0
var time_passed: float = 0.0

func _ready() -> void:
	if crop_data == null:
		return
		
	sprite.texture = crop_data.sprite_sheet
	
func _process(delta: float):
	if crop_data == null:
		return
	
	time_passed += delta
	var stage_duration = crop_data.grow_time / crop_data.frames
	var new_stage = int(time_passed / stage_duration)
	if new_stage != stage and new_stage < crop_data.frames:
		stage = new_stage
		_update_sprite()

func _update_sprite():
	var row = crop_data.start_coords.y
	var col = crop_data.start_coords.x - stage	# step left from fully grown
	var frame_index = row * sprite.hframes + col
	sprite.frame = frame_index

	#sprite.frame = 5
