extends TileMapLayer

## Sends out tile position as [Vector2i].
signal tile_selected(coordinate: Vector2i)

## Handles inputs of the mouse and converts that to current tile.
func _unhandled_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
		):
			var canvas_pos: Vector2 = make_canvas_position_local(event.global_position)
			var tile_map_pos: Vector2i = local_to_map(canvas_pos)
			print(tile_map_pos)
			tile_selected.emit(tile_map_pos)
			
