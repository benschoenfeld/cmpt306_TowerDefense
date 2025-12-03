extends GutTest

var tower_bag_script = preload("res://defenses/tower_bag/tower_bag.gd")
var tower_bag: TowerBag
var mock_tool_manager: Node

# mock ToolManager
class MockToolManager:
	extends ToolManager
	func _init():
		current_tool_index = 1

# mock TowerResource
class MockTowerResource:
	extends TowerResource
	func _init():
		icon = null
		tower_name = "test"

func before_each():
	tower_bag = TowerBag.new()
	mock_tool_manager = MockToolManager.new()
	tower_bag.tool_manager = mock_tool_manager
	tower_bag.required_tool_index = 1
	tower_bag.tower_choices = [MockTowerResource.new(), MockTowerResource.new()]
	add_child_autofree(tower_bag)

# _update_visibility()
func test_update_visibility():
	mock_tool_manager.current_tool = 1
	tower_bag._update_visibility()
	assert_true(tower_bag.visible)
	mock_tool_manager.current_tool = 2
	tower_bag._update_visibility()
	assert_false(tower_bag.visible)

# _on_tower_button_pressed()
func test_tower_button_pressed_selects_tower():
	var button = tower_bag.tower_button_holder.get_child(0)
	tower_bag._on_tower_button_pressed(button)
	assert_eq(tower_bag.last_button_selected, button)
