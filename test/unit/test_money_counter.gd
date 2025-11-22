extends GutTest

var money_counter_scene: PackedScene = preload("res://general_ui/hud/money_counter.tscn")
var money_counter: MoneyCounter = money_counter_scene.instantiate()

func before_each():
	add_child_autofree(money_counter)

func test_display_amount():
	# Testing past the min value (0)
	money_counter.display_amount(-1)
	assert_eq(money_counter.money_label.text, "0")
	
	# Testing at min value (0)
	money_counter.display_amount(0)
	assert_eq(money_counter.money_label.text, "0")
	
	# Expected use
	money_counter.display_amount(4242)
	assert_eq(money_counter.money_label.text, "4242")
	
	# Testing past the max value (99999)
	money_counter.display_amount(100000000)
	assert_eq(money_counter.money_label.text, "99999")
	
	# Testing at max value (99999)
	money_counter.display_amount(99999)
	assert_eq(money_counter.money_label.text, "99999")
