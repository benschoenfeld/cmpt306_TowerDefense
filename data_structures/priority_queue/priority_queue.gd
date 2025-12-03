class_name PriorityQueue

extends RefCounted
## Puts the largest number at the front of the queue.
##
## @tutorial: https://www.geeksforgeeks.org/dsa/priority-queue-set-1-introduction/
## Converted the code to be used in godot.

## Stored the number.
var queue: Array = []

## Returns index of parent.
func get_parent(index: int) -> int:
	return int((index - 1) / 2.0)

## Returns index of left child.
func get_left_child(index: int) -> int:
	return 2 * index + 1

## Returns index of right child.
func get_right_child(index: int) -> int:
	return 2 * index + 2

## Shift up to maintain max-heap property.
func shift_up(index: int) -> void:
	while index > 0 and !queue[get_parent(index)].compare_to(queue[index]):
		var old_value = queue[get_parent(index)]
		queue[get_parent(index)] = queue[index]
		queue[index] = old_value
		index = get_parent(index)

## Shift down to maintain max-heap property.
func shift_down(index: int) -> void:
	var size: int = queue.size()
	var max_index: int = index
	var left_child: int = get_left_child(index)
	
	if left_child < size and queue[left_child].compare_to(queue[max_index]):
		max_index = left_child
	
	var right_child: int = get_right_child(index)
	
	if right_child < size and queue[right_child].compare_to(queue[max_index]):
		max_index = right_child

	if index != max_index:
		var old_value = queue[index]
		queue[index] = queue[max_index]
		queue[max_index] = old_value
		shift_down(max_index)

## Insert a new element.
func insert(item) -> bool:
	if item.has_method("compare_to"):
		queue.append(item)
		shift_up(len(queue) - 1)
		return true
	return false

## Extract element with maximum priority.
## Returns the max element.
func pop():
	var size = len(queue)
	if size == 0:
		return null
	var result = queue[0]
	# Put the number at the back to the front.
	queue[0] = queue[size - 1]
	queue.remove_at(queue.size()-1)
	shift_down(0)
	return result

## Return current maximum element.
func get_max():
	if queue.is_empty():
		return null
	return queue[0]
