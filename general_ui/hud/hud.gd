class_name HUD
extends Control

@export_category("Enums")
## Give the enum for tools that can be shared between scenes.
@export var tool_enum: ToolEnums

# fetch game manager class
var manager: GameManager

# fetch currently selected tool
# var selected: ToolEnums.Tool

# player money resource
var count: int

# catch selection signals
func _ready() -> void:
	pass

# update tool view
func _process(float) -> void:
	pass
