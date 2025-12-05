extends GutTest

# Preload the Spawner script
var SpawnerScript = preload("res://enemies/scripts/spawner.gd")

var spawner: Spawner
var path: Path2D
var mock_enemy_scene: PackedScene

func before_each():
	# Create Path2D for spawner
	path = Path2D.new()
	var curve = Curve2D.new()
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(100,0))
	path.curve = curve
	add_child(path)

	# Create mock Enemy scene
	var enemy = Enemy.new()
	mock_enemy_scene = PackedScene.new()
	mock_enemy_scene.pack(enemy)

	# Create spawner
	spawner = SpawnerScript.new()
	spawner.path = path
	spawner.enemy_scene = mock_enemy_scene
	add_child(spawner)

func after_each():
	if is_instance_valid(spawner):
		spawner.queue_free()

# spawn_wave()
func test_spawn_wave_creates_multiple_enemies():
	var enemy_type = EnemyType.new()

	# sequence
	var seq = EnemySequence.new()
	seq.amount = 3
	seq.enemy_type = enemy_type
	seq.interval = 0.01

	# wave
	var wave = Wave.new()
	wave.sequences.append(seq)

	# initial count
	var before = path.get_child_count()
	# spawn wave
	# spawner.spawn_wave(wave)
	var after = path.get_child_count()
	
	assert_eq(after, before + 3, "Spawn wave should spawn all enemies")
	for i in range(before, after):
		var enemy_instance = path.get_child(i)
		assert_true(enemy_instance is Enemy)

# spawn_enemy()
func test_enemies_left_signal():
	# spawn single enemy
	var enemy_type = EnemyType.new()
	spawner.enemy_scene = mock_enemy_scene
	spawner.path = path
	# spawner.spawn_enemy()

	# count should be 0
	#assert_eq(enemy_instance.type, enemy_type)
	#assert_eq(enemy_instance.progress_ratio, 0.0)
