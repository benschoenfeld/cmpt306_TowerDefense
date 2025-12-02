class_name PriorityQueue

extends RefCounted
##
##
## @tutorial: https://www.geeksforgeeks.org/dsa/priority-queue-set-1-introduction/

var queue: Array = []

# Returns index of parent
func get_parent(index: int):
	return int((index - 1) / 2)

# Returns index of left child
func get_left_child(index: int):
	return 2 * index + 1

# Returns index of right child
func get_right_child(index: int):
	return 2 * index + 2

# Shift up to maintain max-heap property
func shiftUp(index: int):
	while index > 0 and queue[get_parent(index)] < queue[index]:
		var old_value = queue[get_parent(index)]
		queue[get_parent(index)] = queue[index]
		queue[index] = old_value
		index = get_parent(index)

# Shift down to maintain max-heap property
func shiftDown(index: int):
	var size: int = queue.size()
	var maxIndex = index
	var l = get_left_child(index)
	if l < size and queue[l] > queue[maxIndex]:
		maxIndex = l
	var r = get_right_child(index)
	if r < size and queue[r] > queue[maxIndex]:
		maxIndex = r

	if index != maxIndex:
		var old_value = queue[index]
		queue[index] = queue[maxIndex]
		queue[maxIndex] = old_value
		shiftDown(maxIndex)

# Insert a new element
func insert(p):
	queue.append(p)
	shiftUp(len(queue) - 1)

# Extract element with maximum priority
func pop():
	var size = len(queue)
	if size == 0:
		return -1
	var result = queue[0]
	queue[0] = queue[size - 1]
	queue.remove_at(0)
	shiftDown(0)
	return result

# Get current maximum element
func getMax():
	if queue.is_empty():
		return -1
	return queue[0]
