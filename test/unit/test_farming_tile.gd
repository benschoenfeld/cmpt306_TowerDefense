extends GutTest

func test_set_tile_stats():
	pass

func test_get_tile_stats():
	pass

func test_set_crop():
	pass

func test_get_crop():
	pass

func test_has_crop():
	pass

func test_set_saturation():
	var farm_tile: FarmingTile = FarmingTile.new()
	farm_tile._ready()
	# Set it to a positive number
	farm_tile.set_saturation(42.0)
	assert_eq(farm_tile.get_saturation(), 42.0)
	
	# Try to set it to a negative number
	farm_tile.set_saturation(-42.0)
	assert_eq(farm_tile.get_saturation(), 0.0)

func test_get_saturation():
	var farm_tile: FarmingTile = FarmingTile.new()
	
	assert_eq(farm_tile.get_saturation(), 0.0)
	
	farm_tile.set_saturation(1.0)
	assert_eq(farm_tile.get_saturation(), 1.0)

func test_add_saturation():
	var farm_tile: FarmingTile = FarmingTile.new()
	
	# Adding saturation from 0
	farm_tile.add_saturation(5.5)
	assert_eq(farm_tile.get_saturation(), 5.5)
	
	# Adding saturation from a number greater than 0.
	farm_tile.add_saturation(4.5)
	assert_eq(farm_tile.get_saturation(), 10.0)
	
	# Testing adding negative numbers 
	farm_tile.add_saturation(-10.0)
	assert_eq(farm_tile.get_saturation(), 0.0)
	
	# Testing adding negative numbers that would go into the negatives
	farm_tile.add_saturation(-9.0)
	assert_eq(farm_tile.get_saturation(), 0.0)

func test_has_saturation():
	var farm_tile: FarmingTile = FarmingTile.new()
	
	# Test when saturation is 0
	assert_eq(farm_tile.has_saturation(), false)
	
	# Tests when 0 < saturation
	farm_tile.set_saturation(1.0)
	assert_eq(farm_tile.has_saturation(), true)
