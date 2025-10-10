class_name SeedBag

extends Control
## Holds the crops that the player can plant.

## Allows tools to see what seed is selected.
signal selected_seed(seed_selection)

## The options for what crops can be planted.
@export var seed_choices = [1, 2, 3] # TODO: remove these placeholder items

@export var seed_button_holder: GridContainer

## The current seed selected.
var current_seed_selected

func _ready() -> void:
	_setup_seed_buttons()

## Once a button is pressed send the selected crop as a signal.
func _send_seed_info(button) -> void:
	# Gets the end value within the name of the button
	var button_value: int = int(str(button.name)[-1])
	current_seed_selected = seed_choices[button_value]
	selected_seed.emit(current_seed_selected)

## A private function to set up the buttons.
func _setup_seed_buttons() -> void:
	var enabled_buttons: int = 0
	# Connect all buttons to the function and then disable it if 
	# there are not enough seeds for the buttons
	for button: Button in seed_button_holder.get_children():
		button.pressed.connect(_send_seed_info.bind(button))
		if enabled_buttons >= seed_choices.size():
			button.disabled = true
		else:
			enabled_buttons += 1
			# TODO: Set up the visual icons for the buttons 
			# with info from the crops
