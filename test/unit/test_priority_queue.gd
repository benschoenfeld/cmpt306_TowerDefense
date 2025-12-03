extends GutTest

var queue: PriorityQueue

var enemy_scene: PackedScene = preload("res://enemies/scenes/enemy.tscn")
var enemy1: Enemy
var enemy2: Enemy
var enemy3: Enemy

func before_each():
	queue = PriorityQueue.new()
	enemy1 = enemy_scene.instantiate()
	enemy2 = enemy_scene.instantiate()
	enemy3 = enemy_scene.instantiate()
	enemy1.progress += 100
	enemy3.progress += 2000

func after_each():
	for enemy in [enemy1, enemy2, enemy3]:
		enemy.free()

func test_shift_up():
	queue.queue = [enemy1, enemy2, enemy3]
	queue.shift_up(2)
	assert_eq(queue.queue, [enemy3, enemy2, enemy1])

func test_insert():
	queue.insert(enemy1)
	assert_eq(queue.queue[0], enemy1)
	
	queue.insert(enemy2)
	assert_eq(queue.queue[1], enemy2)
	
	queue.insert(enemy3)
	assert_eq(queue.queue[0], enemy3)
	
func test_get_parent():
	queue.insert(enemy1)
	assert_eq(queue.get_parent(0), 0)
	
	queue.insert(enemy2)
	assert_eq(queue.get_parent(1), 0)
	
	queue.insert(enemy3)
	assert_eq(queue.get_parent(2), 0)

func test_get_left_child():
	queue.insert(enemy1)
	queue.insert(enemy2)
	queue.insert(enemy3)
	
	assert_eq(queue.get_left_child(0), 1)

func test_get_right_child():
	queue.insert(enemy1)
	queue.insert(enemy2)
	queue.insert(enemy3)
	
	assert_eq(queue.get_right_child(0), 2)

func test_shift_down():
	queue.queue = [enemy1, enemy2, enemy3]
	queue.shift_up(2)
	assert_eq(queue.queue, [enemy3, enemy2, enemy1])

func test_pop():
	queue.insert(enemy1)
	queue.insert(enemy2)
	queue.insert(enemy3)
		
	assert_eq(queue.pop(), enemy3)
	assert_eq_deep(queue.queue, [enemy1, enemy2])
	
	assert_eq(queue.pop(), enemy1)
	assert_eq_deep(queue.queue, [enemy2])

func test_get_max():
	assert_eq(queue.get_max(), null)
	
	queue.insert(enemy1)
	assert_eq(queue.get_max(), enemy1)
	
	queue.insert(enemy2)
	queue.insert(enemy3)
	assert_eq(queue.get_max(), enemy3)

func test_insert_enemies():
	queue.insert(enemy1)
	queue.insert(enemy2)
	queue.insert(enemy3)
	assert_eq(queue.get_max(), enemy3)
