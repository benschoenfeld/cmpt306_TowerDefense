extends GutTest

var pause_menu_scene: PackedScene = preload("res://general_ui/pause_menu/pause_menu.tscn")
var pause_menu: PauseMenu

func before_each():
	pause_menu = pause_menu_scene.instantiate()
	add_child_autofree(pause_menu)

func test_set_pause():
	pause_menu.set_pause(true)
	
	assert_eq(pause_menu.visible, true)
	assert_eq(get_tree().paused, true)
	
	pause_menu.set_pause(false)
	assert_eq(pause_menu.visible, false)
	assert_eq(get_tree().paused, false)
