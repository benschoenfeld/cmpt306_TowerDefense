extends Control
class_name TowerBag

## Emitted when player selects a tower type from UI.
##
## @param tower_selection The [TowerResource] chosen.
signal selected_tower(tower_selection: TowerResource)

## List of tower types to show in the UI
@export var tower_choices: Array[TowerResource] = [
	preload("res://defenses/resources/tower_1.tres"),
	preload("res://defenses/resources/tower_2.tres"),
	preload("res://defenses/resources/tower_missile.tres")
]

## Container that holds UI elements for each tower option.
@export var tower_button_holder: GridContainer

## The selected tower resource, or null if none selected.
var current_tower_selected: TowerResource = null

## A reference to last selected button.
var last_button_selected: Button = null

## Initializes the tower selection UI.
##
## Assigns each button a tower index, sets icons and adds cost labels.
func _ready() -> void:
	var idx := 0
	
	for vbox: VBoxContainer in tower_button_holder.get_children():
		var button: Button = vbox.get_child(0)
		button.set_meta("tower_index", idx)
		button.pressed.connect(_on_tower_button_pressed.bind(button))
		
		# Disable button if tower choice does not exists
		if idx >= tower_choices.size():
			button.disabled = true
		else:
			var towerRes: TowerResource = tower_choices[idx]
			# Set tower icon
			if towerRes.icon:
				button.icon = towerRes.icon
				button.expand_icon = true
			
			# Add cost label beneath button
			var money_label: Label = Label.new()
			money_label.text = "$" + str(towerRes.get_cost())
			money_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			money_label.label_settings = preload("res://defenses/assets/tower_bag_money_font.tres")
			vbox.add_child(money_label)
		idx += 1

## Handles tower button presses.
##
## Updates the selected tower and visually highlights that button.
##
## @param button The button that was pressed by player.
func _on_tower_button_pressed(button: Button) -> void:
	# Reset highlight for previously button
	if last_button_selected:
		last_button_selected.modulate = Color(1,1,1,1)
	last_button_selected = button
	_show_selection(button)
	
	# Retrieve index and check if tower exists
	var i := int(button.get_meta("tower_index"))
	if i < tower_choices.size():
		current_tower_selected = tower_choices[i]
		emit_signal("selected_tower", current_tower_selected)
	else:
		current_tower_selected = null
		emit_signal("selected_tower", null)

## Visually highlights the button to show that it is selected.
##
## @param button The button to highlight.
func  _show_selection(button: Button) -> void:
	button.modulate = Color(0.916, 0.437, 0.0, 0.7)
