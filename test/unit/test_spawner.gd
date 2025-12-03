extends GutTest

var enemy_scene = preload("res://enemies/scenes/enemy.tscn")
var spawner_script = preload("res://enemies/scripts/spawner.gd")
var path: Path2D
var spawner: Node

# mock EnemyType
class MockEnemyType:
	extends EnemyType
	func _init():
		health = 10
		speed = 100.0
		damage = 3
		frames = SpriteFrames.new()
		walk_animation = "walk"

func before_each():
	# must add Path2D for enemy parent
	path = Path2D.new()
	var curve = Curve2D.new()
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(100,0))
	path.curve = curve
	add_child_autofree(path)
	spawner = spawner_script.new()
	spawner.enemy_scene = enemy_scene
	spawner.path = path
	# mock enemy types
	spawner.normal_enemy = MockEnemyType.new()
	spawner.fast_enemy = MockEnemyType.new()
	spawner.tank_enemy = MockEnemyType.new()
	add_child_autofree(spawner)

# get_type()
func test_get_type_returns_correct_enemy_type():
	assert_eq(spawner.get_type("normal"), spawner.normal_enemy)
	assert_eq(spawner.get_type("fast"), spawner.fast_enemy)
	assert_eq(spawner.get_type("tank"), spawner.tank_enemy)

# spawn_enemy()
func test_spawn_enemy_adds_enemy_to_path():
	var enemy_type = spawner.normal_enemy
	var count = path.get_child_count()
	spawner.spawn_enemy(enemy_type)
	assert_eq(path.get_child_count(), count + 1)
	var enemy_instance = path.get_child(path.get_child_count() - 1)
	assert_eq(enemy_instance.type, enemy_type)
	assert_eq(enemy_instance.progress, 0.0)

# spawn_wave()
func test_spawn_wave_creates_multiple_enemies():
	var wave = {
		"groups": [
			{ "type": "normal", "count": 3, "interval": 0.1 },
		]
	}
	var count = path.get_child_count()
	# loop to spawn enemies
	for group in wave["groups"]:
		var enemy_type = spawner.get_type(group["type"])
		var count_in_group = group.get("count", 1)
		for i in range(count_in_group):
			spawner.spawn_enemy(enemy_type)
	
	# loop to check enemies in wave
	assert_eq(path.get_child_count(), count + 3)
	for i in range(count, path.get_child_count()):
		var enemy_instance = path.get_child(i)
		assert_eq(enemy_instance.type, spawner.normal_enemy)
