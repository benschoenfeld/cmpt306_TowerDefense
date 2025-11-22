extends GutTest

func test_get_value():
	var crop_resource: CropResource = CropResource.new()
	
	crop_resource.value = 10
	assert_eq(crop_resource.get_value(), 10)
