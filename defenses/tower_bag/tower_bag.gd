extends Control
class_name TowerBag

signal selected_tower(tower_selection: TowerResource)

@export var tower_choices: Array[TowerResource] = [
	preload("res://defenses/resources/tower_1.tres"),
	preload("res://defenses/resources/tower_2.tres"),
	preload("res://defenses/resources/tower_missile.tres")
]

@export var tower_button_holder: GridContainer

var current_tower_selected: TowerResource = null
var last_button_selected: Button = null

func _ready() -> void:
	var idx := 0
	
	for vbox: VBoxContainer in tower_button_holder.get_children():
		var button: Button = vbox.get_child(0)
		button.set_meta("tower_index", idx)
		button.pressed.connect(_on_tower_button_pressed.bind(button))
		
		if idx >= tower_choices.size():
			button.disabled = true
		else:
			var towerRes: TowerResource = tower_choices[idx]
			if towerRes.icon:
				button.icon = towerRes.icon
				button.expand_icon = true
			
			var money_label: Label = Label.new()
			money_label.text = "$" + str(towerRes.get_cost())
			money_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			money_label.label_settings = preload("res://defenses/assets/tower_bag_money_font.tres")
			vbox.add_child(money_label)
		idx += 1
		
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

func  _show_selection(button: Button) -> void:
	button.modulate = Color(0.916, 0.437, 0.0, 0.7)
