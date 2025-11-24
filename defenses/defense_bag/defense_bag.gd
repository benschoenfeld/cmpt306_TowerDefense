extends Control
class_name DefenseBag

signal selected_deffense(defense_selection: DefenseResource)

@export var tool_manager: ToolManager

@export var required_tool_index: int


@export var defense_choices: Array[DefenseResource] = [
	preload("res://defenses/resources/defense_basic.tres"),
	preload("res://defenses/resources/defense_double.tres")
]

@export var defense_button_holder: GridContainer

var current_defense_selected: DefenseResource = null
var last_button_selected: Button = null

func _ready() -> void:
	if tool_manager == null:
		tool_manager = get_tree().get_root().find_node("ToolManager", true, false)
		if tool_manager == null:
			push_warning("DefenseBag: tool_manager not set")
			
	if tool_manager:
		required_tool_index = int(tool_manager.tool_enum.Tool.TARGET)
	else:
		if required_tool_index == 0:
			required_tool_index = -1
	
	if tool_manager and not is_connected("selected_defense", Callable(tool_manager, "_on_defense_bag_selected_defense")):
		connect("selected_defense", Callable(tool_manager, "_on_defense_bag_selected_defense"))
	var idx := 0
	_update_visibility()
	
	if tool_manager.has_signal("tool_changed"):
		if not tool_manager.is_connected("tool_changed", Callable(self, "_on_tool_changed")):
			tool_manager.connect("tool_changed", Callable(self, "_on_tool_changed"))
	
		
	for button: Button in defense_button_holder.get_children():
		button.set_meta("defense_index", idx)
		button.pressed.connect(_on_defense_button_pressed.bind(button))
		
		if idx >= defense_choices.size():
			button.disabled = true
		else:
			var defenseRes: DefenseResource = defense_choices[idx]
			if defenseRes.icon:
				button.icon = defenseRes.icon
				button.expand_icon = true
		idx += 1

func _on_tool_changed(tool_index: int) -> void:
	_update_visibility()
	
func _update_visibility() -> void:
	if tool_manager.has_method("get_current_tool"):
		visible = (tool_manager.get_current_tool() == required_tool_index)
	else:
		visible = false

func _on_defense_button_pressed(button: Button) -> void:
	if last_button_selected:
		last_button_selected.modulate = Color(1,1,1,1)
	last_button_selected = button
	_show_selection(button)
	
	var i := int(button.get_meta("defense_index"))
	if i < defense_choices.size():
		current_defense_selected = defense_choices[i]
		emit_signal("selected_defense", current_defense_selected)
	else:
		current_defense_selected = null
		emit_signal("selected_defense", null)
		
func  _show_selection(button: Button) -> void:
	button.modulate = Color(0.916, 0.437, 0.0, 0.7)
	
		
