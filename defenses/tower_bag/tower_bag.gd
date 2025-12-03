extends Control
class_name TowerBag

signal selected_tower(tower_selection: TowerResource)

@export var tool_manager: ToolManager

@export var required_tool_index: int


@export var tower_choices: Array[TowerResource] = [
	preload("res://defenses/resources/tower_1.tres"),
	preload("res://defenses/resources/tower_2.tres"),
	preload("res://defenses/resources/tower_missile.tres")
]

@export var tower_button_holder: GridContainer

var current_tower_selected: TowerResource = null
var last_button_selected: Button = null

## base initial logic for tower bag
func _ready() -> void:
	if tool_manager == null:
		tool_manager = get_tree().get_root().find_node("ToolManager", true, false)
		if tool_manager == null:
			push_warning("TowerBag: tool_manager not set")
			
	if tool_manager:
		required_tool_index = int(tool_manager.tool_enum.Tool.TARGET)
	else:
		if required_tool_index == 0:
			required_tool_index = -1
	
	if tool_manager and not is_connected("selected_tower", Callable(tool_manager, "_on_tower_bag_selected_tower")):
		connect("selected_tower", Callable(tool_manager, "_on_tower_bag_selected_tower"))
	var idx := 0
	_update_visibility()
	
	if tool_manager.has_signal("tool_changed"):
		if not tool_manager.is_connected("tool_changed", Callable(self, "_on_tool_changed")):
			tool_manager.connect("tool_changed", Callable(self, "_on_tool_changed"))
	
		
	for button: Button in tower_button_holder.get_children():
		button.set_meta("tower_index", idx)
		button.pressed.connect(_on_tower_button_pressed.bind(button))
		
		if idx >= tower_choices.size():
			button.disabled = true
		else:
			var towerRes: TowerResource = tower_choices[idx]
			if towerRes.icon:
				button.icon = towerRes.icon
				button.expand_icon = true
		idx += 1

## calls when tool is changed to update UI
func _on_tool_changed(tool_index: int) -> void:
	_update_visibility()

## updates the tool manager UI
func _update_visibility() -> void:
	if tool_manager.has_method("get_current_tool"):
		visible = (tool_manager.get_current_tool() == required_tool_index)
	else:
		visible = false

## connects signals for each tower in tower bag
func _on_tower_button_pressed(button: Button) -> void:
	if last_button_selected:
		last_button_selected.modulate = Color(1,1,1,1)
	last_button_selected = button
	_show_selection(button)
	
	var i := int(button.get_meta("tower_index"))
	if i < tower_choices.size():
		current_tower_selected = tower_choices[i]
		emit_signal("selected_tower", current_tower_selected)
	else:
		current_tower_selected = null
		emit_signal("selected_tower", null)

## turns selected button yellow
func  _show_selection(button: Button) -> void:
	button.modulate = Color(0.916, 0.437, 0.0, 0.7)
