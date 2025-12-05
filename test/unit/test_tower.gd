extends GutTest

var tower_script = preload("res://defenses/tower.gd")
var tower_scene = preload("res://defenses/tower.tscn")
var tower: Tower
var game_manager: Node
var tool_manager: Node
var tower_instance_scene: PackedScene
var tower_base: Node2D

# mock ToolManager
class MockToolManager:
	extends ToolManager
	func _init():
		selected_tower = null
		current_tool_index = 1
	func _set_current_tool(i):
		pass
	

# mock GameManager
class MockGameManager:
	extends GameManager
	func _init():
		money_amount = 100
	func set_money(new_amount):
		money_amount = new_amount
	func add_money(amount):
		money_amount += amount
	func _set_up_model():
		pass
	func _ready():
		pass

func before_each():
	tower = Tower.new()
	add_child_autofree(tower)
	# mock managers
	tool_manager = MockToolManager.new()
	tower.tool_manager = tool_manager
	add_child_autofree(tool_manager)
	
	game_manager = MockGameManager.new() # local var for test
	tower.game_manager = game_manager
	add_child_autofree(game_manager)
	
	tower.set("tower_instance", tower_scene)
	tower_base = Node2D.new()
	tower_base.global_position = Vector2(100, 100)
	tower_base.add_to_group("TowerBases")
	add_child_autofree(tower_base)

func after_each():
	for child in get_children():
		child.queue_free()

# _snap_position()
func test_snap_position_snaps_to_grid():
	tower.grid_size = Vector2(32, 32)
	var position = Vector2(45, 77)
	var snap = tower._snap_position(position)
	assert_eq(snap, Vector2(32, 64))

# build_base()
func test_build_base_returns_closest_unoccupied_base():
	var position = Vector2(110, 110)
	var base = tower.build_base(position, 50)
	assert_eq(base, tower_base)

# build_base()
func test_build_base_returns_null_if_occupied():
	tower_base.set_meta("occupied", true)
	var position = Vector2(110, 110)
	var base = tower.build_base(position, 50)
	assert_eq(base, null)

# _can_afford_a_tower()
func test_can_afford_a_tower_returns_true_or_false():
	# money_amount = 100
	assert_true(tower._can_afford_a_tower(50)) # < 100
	assert_false(tower._can_afford_a_tower(200)) # > 100

# _buy_tower()
func test_buy_tower_deducts_money():
	var start_money = game_manager.money_amount
	tower._buy_tower(40)
	assert_eq(game_manager.money_amount, start_money - 40)
