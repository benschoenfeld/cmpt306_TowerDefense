class_name SeedBag

extends Control
## Holds the crops that the player can plant.

## Allows tools to see what seed is selected.
signal selected_seed(seed_selection: CropResource)

## The options for what crops can be planted.
@export var seed_choices: Array[CropResource] = [
		preload("res://crops/resources/corn.tres"), 
		preload("res://crops/resources/eggplant.tres"), 
		preload("res://crops/resources/radish.tres"), 
		]

@export var seed_button_holder: GridContainer

## The current seed selected.
var current_seed_selected: CropResource

## The last [Button] selected that relates to the last [param current_seed_selected].
var last_button_selected: Button

func _ready() -> void:
	_setup_seed_buttons()

## Setter for the [param current_seed_selected].
func set_current_seed(new_current_seed: CropResource) -> void:
	current_seed_selected = new_current_seed

## Getter for the [param current_seed_selected].
func get_current_seed() -> CropResource:
	return current_seed_selected

## Once a button is pressed send the selected crop as a signal.
func _send_seed_info(button: Button) -> void:
	# Gets the end value within the name of the button
	var button_value: int = int(str(button.name)[-1])
	# This deselects the last button
	if last_button_selected:
		last_button_selected.modulate = Color(1, 1, 1, 1)
	last_button_selected = button
	_show_selection(button)
	current_seed_selected = seed_choices[button_value]
	selected_seed.emit(current_seed_selected)

func _show_selection(button: Button) -> void:
	button.modulate = Color(0.916, 0.437, 0.0, 0.7)

## A private function to set up the buttons.
func _setup_seed_buttons() -> void:
	var enabled_buttons: int = 0

	for button: Button in seed_button_holder.get_children():
		button.pressed.connect(_send_seed_info.bind(button))
		
		# Only enable buttons if there is a seed to fill the button
		if enabled_buttons >= seed_choices.size():
			button.disabled = true
		else:
			# Set icon to the crop type
			var crop_icon: Texture2D = seed_choices[enabled_buttons].icon
			button.icon = crop_icon
			button.expand_icon = true
			
			enabled_buttons += 1
