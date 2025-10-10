class_name SeedBag

extends Control
## Holds the crops that the player can plant.

## Allows tools to see what seed is selected.
signal selected_seed(seed_selection)

const MAX_SEED_SLOTS: int = 9

## The options for what crops can be planted.
@export var seed_choices = []

@export var seed_button_holder: GridContainer

## The current seed selected.
var current_seed_selected

## Once a button is pressed send the selected crop.
func send_seed_info():
	pass

## A private function to set up the buttons
func _setup_seed_buttons():
	pass
