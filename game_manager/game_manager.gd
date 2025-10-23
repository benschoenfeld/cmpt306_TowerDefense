class_name GameManager

extends Node
## This is the scene that puts together game machanics.

## Emits the new amount of money.
signal money_changed(new_amount: int)

## A [PackedScene] of the [PauseMenu].
@export var pause_menu_scene: PackedScene

## The [CanvasLayer] that the pause scene will be added to.
@export var pause_menu_layer: CanvasLayer

## A reference to the [TileMapLayer] that holds the [FarmingTile].
@export var farming_tile_map: TileMapLayer

## A reference to the [ToolManager] to interact with [FarmingTile].
@export var tool_manager: ToolManager

## The players resource.
var money_amount: int = 0


func _ready() -> void:
	_load_and_connect_tile()

## Sets the [param money_amount] and emits a signal.
func set_money(new_amount: int) -> void:
	money_amount = new_amount
	money_changed.emit(money_amount)

## Adds to the [param money_amount].
func add_money(new_amount: int) -> void:
	set_money(get_money() + new_amount)

## Returns the [param money_amount]
func get_money() -> int:
	return money_amount

## Finds all [FarmingTile] and connects them to the [ToolManager].
func _load_and_connect_tile():
	# This is important to update the children being added a children 
	# to the tile map node
	farming_tile_map.update_internals()
	for tile in farming_tile_map.get_children():
		if tile is FarmingTile and tool_manager != null:
			tile.connect("send_tile_data", tool_manager.interact)

## When the pause button is pressed is adds the pause scene to 
## the [param pause_menu_layer].
func _on_pause_button_pressed() -> void:
	var pause_menu: PauseMenu = pause_menu_scene.instantiate()
	pause_menu_layer.add_child(pause_menu)
