extends Node2D
@export var crop_data: CropDataAnimated

var is_grown = false

func _ready() -> void:
	if crop_data == null or crop_data.tres == null:
		print("Crop_data not valid")
		queue_free()
		return
		
	var anim = $AnimatedSprite2D
	anim.sprite_frames = crop_data.frames
	
