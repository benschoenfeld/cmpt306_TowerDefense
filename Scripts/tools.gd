extends Node2D
#
## Loading the tool icons from the /assets director as .png images
var tool_shovel = preload("res://assets/tool_shovel.png")
var tool_hoe = preload("res://assets/tool_hoe.png")
var tool_waterCan = preload("res://assets/tool_watering_can.png")
#
## Defining the constant for Cursor Hotspot
const CURSOR_HOTSPOT = Vector2(16, 16)
# Defining the constant for Cursor Shape
const CURSOR_SHAPE = Input.CURSOR_ARROW

# Array to hold all the different types of tools
var toolArray : Array

# Index of the current selected tool in the array
# tool_shovel   = 0 (set as default)
# tool_waterCan = 1
# tool_hoe      = 2

var current_tool_index = 0

func _ready() -> void:
	# Storing the tools in the array (Will add more tools later)
	toolArray = [tool_shovel, tool_waterCan, tool_hoe]
	
# Setting the 'tool_shovel' as the custom cursor by default
	set_current_tool(current_tool_index)
	
func set_current_tool(index: int) -> void:
	
	# Ensuring the index is within the appropriate range of the toolArray
	if index >= 0 and index < toolArray.size():
		current_tool_index = index
		var selected_tool = toolArray[current_tool_index]
		Input.set_custom_mouse_cursor(selected_tool, CURSOR_SHAPE, CURSOR_HOTSPOT)
	
	
func _unhandled_input(event: InputEvent) -> void:
	var new_index = current_tool_index
	
	if event is InputEventMouseButton:
	
		# Scrolling 'down' (Next tool)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			# Increment the index, and goes back to 0 if it exceeds the size of the toolArray
			new_index = (current_tool_index + 1) % toolArray.size()
			set_current_tool(new_index)
			
		# Scrolling 'up' (Previous tool)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			# Decrements the index, and handles/prevents getting a negative array index
			new_index = (current_tool_index - 1 + toolArray.size()) % toolArray.size()
			set_current_tool(new_index)
		
func _process(delta: float) -> void:
	
	# Hotkeying the showel as the custom cursor when pressed '1' on the keyboard
	if Input.is_action_just_pressed("equip_shovel"):
		set_current_tool(0)
		
	# Hotkeying the water can as the custom cursor when pressed '2' on the keyboard
	if Input.is_action_just_pressed("equip_waterCan"):
		set_current_tool(1)
		
	# Hotkeying the hoe as the custom cursor when pressed '3' on the keyboard
	if Input.is_action_just_pressed("equip_hoe"):
		set_current_tool(2)
