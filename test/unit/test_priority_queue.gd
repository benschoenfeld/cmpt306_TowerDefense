extends GutTest

var queue: PriorityQueue

func before_each():
	queue = PriorityQueue.new()

func test_shift_up():
	queue.queue = [5, 4, 10]
	queue.shift_up(2)
	assert_eq(queue.queue, [10, 4, 5])

func test_insert():
	queue.insert(5)
	assert_eq(queue.queue[0], 5)
	
	queue.insert(4)
	assert_eq(queue.queue[0], 5)
	
	queue.insert(10)
	assert_eq(queue.queue[0], 10)
	
func test_get_parent():
	queue.insert(5)
	assert_eq(queue.get_parent(0), 0)
	
	queue.insert(4)
	assert_eq(queue.get_parent(1), 0)
	
	for i in range(3):
		queue.insert(i)
	
	assert_eq(queue.get_parent(4), 1)
	assert_eq(queue.get_parent(3), 1)

func test_get_left_child():
	for i in range(5):
		queue.insert(i)
	
	assert_eq(queue.get_left_child(0), 1)
	assert_eq(queue.get_left_child(1), 3)

func test_get_right_child():
	for i in range(5):
		queue.insert(i)
	
	assert_eq(queue.get_right_child(0), 2)
	assert_eq(queue.get_right_child(1), 4)

func test_shift_down():
	queue.queue = [5, 4, 10]
	queue.shift_down(0)
	assert_eq(queue.queue, [10, 4, 5])

func test_pop():
	for i in range(5):
		queue.insert(i)
		
	assert_eq(queue.pop(), 4)
	assert_eq_deep(queue.queue, [3, 2, 1, 0])
	
	assert_eq(queue.pop(), 3)
	assert_eq_deep(queue.queue, [2, 0, 1])

func test_get_max():
	assert_eq(queue.get_max(), null)
	
	queue.insert(5)
	assert_eq(queue.get_max(), 5)
	
	queue.insert(10)
	assert_eq(queue.get_max(), 10)
