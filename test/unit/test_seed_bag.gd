extends GutTest

var seed_bag_scene: PackedScene = preload("res://seed_bag/seed_bag.tscn")
var seed_bag: SeedBag
var crop_resource: CropResource = preload("res://crops/resources/eggplant.tres")


func before_each():
	seed_bag = seed_bag_scene.instantiate()
	add_child_autofree(seed_bag)

func test_set_current_seed():
	seed_bag.set_current_seed(crop_resource)
	assert_eq(seed_bag.current_seed_selected, crop_resource)

func test_get_current_seed():
	assert_eq(seed_bag.get_current_seed(), null)
	
	seed_bag.set_current_seed(crop_resource)
	assert_eq(seed_bag.get_current_seed(), crop_resource)
