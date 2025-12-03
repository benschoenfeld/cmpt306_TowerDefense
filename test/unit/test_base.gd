extends GutTest

var build_base: BuildBase
var tower_instance: Node2D

# mock TowerInstance
class MockTowerInstance:
	extends TowerInstance

func before_each():
	build_base = BuildBase.new()
	var holder = Node2D.new()
	holder.name = "TowerHolder"
	build_base.add_child(holder)
	add_child_autofree(build_base)
	build_base.tower_holder = holder
	build_base._ready()
	tower_instance = MockTowerInstance.new()

func after_each():
	for child in get_children():
		child.queue_free()

# is_in_group()
func test_added_to_towerbases_group():
	assert_true(build_base.is_in_group("TowerBases"))

# get_meta()
func test_initial_occupied_meta():
	assert_eq(build_base.get_meta("occupied"), false)

# set_tower()
func test_set_tower_adds_child():
	build_base.set_tower(tower_instance)
	assert_true(build_base.tower_holder.has_node(tower_instance.get_path()))
