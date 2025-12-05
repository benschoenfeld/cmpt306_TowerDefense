extends GutTest

var tower_bag_script = preload("res://defenses/tower_bag/tower_bag.gd")
var tower_bag: TowerBag

# Mock TowerResource
class MockTowerResource:
	extends TowerResource
	func _init():
		icon = null
		tower_name = "Test Tower"
	func get_cost() -> int:
		return 50

func before_each():
	# TowerBag instance
	tower_bag = TowerBag.new()

	# tower_button_holder
	var grid = GridContainer.new()
	tower_bag.tower_button_holder = grid
	add_child_autofree(grid)
	add_child_autofree(tower_bag)
	# mock tower choices
	tower_bag.tower_choices = [MockTowerResource.new(), MockTowerResource.new()]
	# for each tower add a button as child to mock scene
	for i in tower_bag.tower_choices:
		var vbox = VBoxContainer.new()
		var button = Button.new()
		vbox.add_child(button)
		grid.add_child(vbox)
	tower_bag._ready()

func after_each():
	for child in get_children():
		child.queue_free()

# _ready() sets up buttons correctly
func test_ready_assigns_button_meta_and_icons():
	for i in range(tower_bag.tower_button_holder.get_child_count()):
		var vbox: VBoxContainer = tower_bag.tower_button_holder.get_child(i)
		var button: Button = vbox.get_child(0)
		assert_eq(button.get_meta("tower_index"), i, "Button should have correct index")
		assert_false(button.disabled, "Button should be enabled")

# _on_tower_button_pressed
func test_on_tower_button_pressed_highlights_button():
	var vbox: VBoxContainer = tower_bag.tower_button_holder.get_child(0)
	var button: Button = vbox.get_child(0)
	tower_bag._on_tower_button_pressed(button)
	assert_eq(button.modulate, Color(0.916, 0.437, 0.0, 0.7), "Button should be highlighted")
