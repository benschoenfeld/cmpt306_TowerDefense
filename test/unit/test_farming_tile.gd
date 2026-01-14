extends GutTest

var farm_tile: PackedScene
var tile_instance: FarmingTile

var grass_stats: FarmingTileStats = preload("res://tiles/farming_tile/resources/grass.tres")
var dry_dirt_stats: FarmingTileStats = preload("res://tiles/farming_tile/resources/dry_dirt.tres")
var wet_dirt_stats: FarmingTileStats = preload("res://tiles/farming_tile/resources/wet_dirt.tres")

func before_each():
	farm_tile = preload("res://tiles/farming_tile/farming_tile.tscn")
	tile_instance = farm_tile.instantiate()
	tile_instance.set_process(false)
	add_child_autofree(tile_instance)

func test_set_saturation():
	# Should be 0 based on grass stats
	tile_instance.set_saturation(42.0)
	assert_eq(tile_instance.get_saturation(), 0.0)
	
	# Should be 0 based on dry dirt stats
	tile_instance.set_tile_stats(dry_dirt_stats)
	tile_instance.set_saturation(42.0)
	assert_eq(tile_instance.get_saturation(), 0.0)
	
	# Should be 3 based on wet dirt stats
	tile_instance.set_tile_stats(wet_dirt_stats)
	tile_instance.set_saturation(42.0)
	assert_eq(tile_instance.get_saturation(), 3.0)
	
	# Try to set it to a negative number
	tile_instance.set_saturation(-42.0)
	assert_eq(tile_instance.get_saturation(), 0.0)

func test_get_saturation():
	assert_eq(tile_instance.get_saturation(), 0.0)
	
	tile_instance.set_tile_stats(wet_dirt_stats)
	tile_instance.set_saturation(1.0)
	assert_eq(tile_instance.get_saturation(), 1.0)

func test_add_saturation():
	# Adding saturation from 0
	tile_instance.get_tile_stats().max_saturation = 10
	tile_instance.add_saturation(5.5)
	assert_eq(tile_instance.get_saturation(), 5.5)
	
	# Adding saturation from a number greater than 0.
	tile_instance.add_saturation(4.5)
	assert_eq(tile_instance.get_saturation(), 10.0)
	
	# Testing adding negative numbers 
	tile_instance.add_saturation(-10.0)
	assert_eq(tile_instance.get_saturation(), 0.0)
	
	# Testing adding negative numbers that would go into the negatives
	tile_instance.add_saturation(-9.0)
	assert_eq(tile_instance.get_saturation(), 0.0)

func test_has_saturation():
	# Test when saturation is 0
	assert_eq(tile_instance.has_saturation(), false)
	
	# Tests when 0 < saturation
	tile_instance.set_saturation(1.0)
	assert_eq(tile_instance.has_saturation(), true)

func test_get_tile_stats():
	# Testing when first added in to scene
	assert_eq(tile_instance.get_tile_stats(), grass_stats)
	
	# Testing when stats are changed
	tile_instance.set_tile_stats(dry_dirt_stats)
	assert_eq(tile_instance.get_tile_stats(), dry_dirt_stats)
	
	# Testing when stats are changed
	tile_instance.set_tile_stats(wet_dirt_stats)
	assert_eq(tile_instance.get_tile_stats(), wet_dirt_stats)
	
	# Testing when stats are null
	tile_instance.set_tile_stats(null)
	assert_eq(tile_instance.get_tile_stats(), null)

func test_get_tile_type():
	# When current stats is not null
	assert_eq(tile_instance.get_tile_type(), FarmingTileStats.TileType.GRASS)

func test_set_tile_stats():
	# Once the tils is changes does it update and does it change the sprite?
	tile_instance.set_tile_stats(dry_dirt_stats)
	assert_eq(tile_instance.get_tile_stats(), dry_dirt_stats)
	assert_eq(tile_instance.tile_sprite.frame, FarmingTileStats.TileType.DRY_DIRT)

func test_get_crop():
	# Null when there is no crop
	assert_eq(tile_instance.get_crop(), null)
	
	tile_instance.set_crop(CropResource.new())
	assert_ne(tile_instance.get_crop(), null)

func test_set_crop():
	# Setting crop from having no crop
	tile_instance.set_crop(CropResource.new())
	assert_eq(tile_instance.has_crop(), true)
	
	# Setting crop while having a crop
	var new_crop = CropResource.new()
	new_crop.crop_name = "new new new"
	tile_instance.set_crop(new_crop)
	assert_eq(tile_instance.get_crop().crop_data.crop_name, "new new new")

func test_has_crop():
	# When tile has no crop
	assert_eq(tile_instance.has_crop(), false)
	
	# When tile has crop
	tile_instance.set_crop(CropResource.new())
	assert_eq(tile_instance.has_crop(), true)

func test_harvest_crop():
	# Try to harvest when there is no crop
	assert_eq(tile_instance.harvest_crop(), null)
	
	# Try to harvest a crop when it is not grown
	var resource1: CropResource = CropResource.new()
	tile_instance.set_crop(resource1)
	assert_eq(tile_instance.harvest_crop(), null)
	assert_ne(tile_instance.get_crop(), null)
	assert_eq(tile_instance.crop_holder.get_child_count(), 1)
	
	# Try to harvest when there is a crop
	var resource2: CropResource = CropResource.new()
	tile_instance.set_crop(resource2)
	tile_instance.get_crop().is_grown = true
	assert_eq(tile_instance.harvest_crop(), resource2)
	assert_eq(tile_instance.get_crop(), null)

func test_apply_water():
	# Tests when tile type is grass
	tile_instance.apply_water(10)
	assert_eq(tile_instance.get_saturation(), 0.0)
	# Tests when tile type is dry dirt
	tile_instance.set_tile_stats(dry_dirt_stats)
	tile_instance.apply_water(10)
	assert_eq(tile_instance.get_saturation(), 3.0)
	
	# Tests when tile type is wet dirt
	tile_instance.set_saturation(1)
	tile_instance.apply_water(10)
	assert_eq(tile_instance.get_saturation(), 3.0)

func test_lower_saturation():
	# Should do nothing to saturation
	tile_instance._lower_saturation(1.0)
	assert_eq(tile_instance.get_saturation(), 0.0)
	
	# Should do nothing to saturation
	tile_instance.set_tile_stats(null)
	tile_instance._lower_saturation(1.0)
	assert_eq(tile_instance.get_saturation(), 0.0)
	
	# Should lower the satuation
	tile_instance.set_tile_stats(wet_dirt_stats)
	tile_instance.set_saturation(3.0)
	tile_instance._lower_saturation(2.0)
	assert_eq(tile_instance.get_saturation(), 2.3)
	
	# Should lower satuation to 0
	tile_instance._lower_saturation(20.0)
	assert_eq(tile_instance.get_saturation(), 0.0)
	tile_instance._lower_saturation(20.0)
	assert_eq(tile_instance.get_tile_type(), FarmingTileStats.TileType.DRY_DIRT)

func test_has_stats():
	# Test to see if returns true when there are stats
	assert_eq(tile_instance.has_stats(), true)
	
	# Test to see if it returns false when there are no stats
	tile_instance.set_tile_stats(null)
	assert_eq(tile_instance.has_stats(), false)
