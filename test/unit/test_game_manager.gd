extends GutTest

var game_manager_scene: PackedScene = preload("res://game_manager/game_manager.tscn")
var game_manager: GameManager = game_manager_scene.instantiate()

func before_all():
	add_child(game_manager)

func after_all():
	game_manager.free()

func test_set_money():
	# Expected  use
	game_manager.set_money(100)
	assert_eq(game_manager.money_amount,  100)
	
	# Adding a negative
	game_manager.set_money(-99)
	assert_eq(game_manager.money_amount, -99)

func test_add_money():
	# Adding a positive
	game_manager.add_money(199)
	assert_eq(game_manager.money_amount,  100)
	
	# Adding a negative
	game_manager.add_money(-99)
	assert_eq(game_manager.money_amount, 1)

func test_get_money():
	assert_eq(game_manager.get_money(), 1)
	
	game_manager.add_money(50)
	assert_eq(game_manager.get_money(), 51)
