extends GutTest

var crop_scene: PackedScene = preload("res://crops/crop.tscn")
var eggplant_resource: CropResource = preload("res://crops/resources/eggplant.tres")
var main_crop: Crop
var resource_for_crop: CropResource

func before_each():
	main_crop = crop_scene.instantiate()
	add_child_autofree(main_crop)

func test_set_crop_resource():
	# when initialized crop data should be null
	assert_eq(main_crop.crop_data, null)
	
	# Expected use
	resource_for_crop = CropResource.new()
	main_crop.set_crop_resource(CropResource.new())
	assert_ne(main_crop.crop_data, null)
	
	# Does it set it when given a specific game resource
	main_crop.set_crop_resource(eggplant_resource)
	assert_eq(main_crop.crop_data, eggplant_resource)

func test_get_crop_resource():
	# Returns null when there is no crop
	assert_eq(main_crop.get_crop_resource(), null)
	
	# Does it get it when given a specific game resource
	main_crop.set_crop_resource(eggplant_resource)
	assert_eq(main_crop.get_crop_resource(), eggplant_resource)

func test_set_parent_tile():
	var farming_tile_scene: PackedScene = preload("res://tiles/farming_tile/farming_tile.tscn")
	var farming_tile = farming_tile_scene.instantiate()
	add_child_autofree(farming_tile)
	
	main_crop.set_parent_tile(farming_tile)
	assert_eq(main_crop.parent_tile, farming_tile)
	
	main_crop.set_parent_tile(null)
	assert_eq(main_crop.parent_tile, null)

func test_get_parent_tile():
	var farming_tile_scene: PackedScene = preload("res://tiles/farming_tile/farming_tile.tscn")
	var farming_tile = farming_tile_scene.instantiate()
	add_child_autofree(farming_tile)
	
	assert_eq(main_crop.get_parent_tile(), null)
	
	main_crop.set_parent_tile(farming_tile)
	assert_eq(main_crop.get_parent_tile(), farming_tile)
