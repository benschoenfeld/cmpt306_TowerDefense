class_name TooltipDetector

extends Area2D
## Detects the mouse and displays stats of object.
##
## Once the player moves the mouse over the area it will pop up a text box
## that will show the stats of the object.

## Holds a reference of the parent node to get the stats.
@export var parent: Node

## Shows the [Tooltip] scene when the mouse hovers over the area.
func show_tooltip() -> void:
	pass

## Hides the [Tooltip] scene when the mouse leaves the area.
func hide_tooltip() -> void:
	pass

## Shows the [Tooltip] scene.
func _on_mouse_entered() -> void:
	pass # Replace with function body.

## Hides the [Tooltip] scene.
func _on_mouse_exited() -> void:
	pass # Replace with function body.
