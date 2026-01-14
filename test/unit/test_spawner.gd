extends GutTest

var SpawnerScript = preload("res://enemies/scripts/spawner.gd")

# mock Enemy
class MockEnemy:
	extends Enemy
	func _init():
		type = preload("res://enemies/resources/Normal.tres")
	func setup(_type): pass # pass functions are to avoid calls in certain places
	func _ready(): pass

# mock HUD
class MockHUD:
	extends HUD
	func update_wave_display(_wave_count): pass
	func show_button(): pass

# mock GameManager
class MockGameManager:
	extends GameManager
	var health = 100
	func _ready(): pass
	func remove_health(damage): health -= damage
	func switch_music(_started): pass

var spawner: Spawner
var path: Path2D
var mock_enemy_scene: PackedScene
var hud: MockHUD
var gm: MockGameManager

func before_each():
	# Path2D for spawner
	path = Path2D.new()
	var curve = Curve2D.new()
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(100,0))
	path.curve = curve
	add_child_autofree(path)
	
	# mock Enemy scene
	var enemy = MockEnemy.new()
	mock_enemy_scene = PackedScene.new()
	mock_enemy_scene.pack(enemy)

	# HUD and GameManager
	hud = MockHUD.new()
	add_child(hud)
	gm = MockGameManager.new()
	add_child(gm)

	# spawner
	spawner = preload("res://enemies/scenes/spawner.tscn").instantiate()
	spawner.path = path
	spawner.enemy_scene = mock_enemy_scene
	spawner.wave_controller = hud
	spawner.game_manager = gm
	add_child(spawner)

func after_each():
	# free test values
	if is_instance_valid(path):
		for child in path.get_children():
			child.queue_free()
	
	if is_instance_valid(spawner):
		spawner.queue_free()
	if is_instance_valid(path):
		path.queue_free()
	if is_instance_valid(hud):
		hud.queue_free()
	if is_instance_valid(gm):
		gm.queue_free()

# spawning a single enemy
func test_spawn_enemy_creates_enemy():
	spawner.enemy_count = 0
	var enemy_type = EnemyType.new()
	spawner.spawn_enemy(enemy_type)
	
	assert_eq(spawner.enemy_count, 1, "Enemy count should increase")
	assert_eq(path.get_child_count(), 1, "Enemy should be added to path")
	var enemy_instance = path.get_child(0)
	assert_true(enemy_instance is MockEnemy)
	assert_eq(enemy_instance.progress_ratio, 0.0)

# spawn_wave() test
func test_spawn_wave_creates_multiple_enemies():
	var enemy_type = EnemyType.new()
	var seq = EnemySequence.new()
	seq.amount = 3
	seq.enemy_type = enemy_type
	seq.interval = 0.01

	var wave = Wave.new()
	wave.sequences.append(seq)

	var before = path.get_child_count()
	await spawner.spawn_wave(wave)
	var after = path.get_child_count()
	
	assert_eq(after, before + 3, "Wave should spawn all enemies")
	for i in range(before, after):
		assert_true(path.get_child(i) is MockEnemy)

# _on_enemy_at_base() reduces health
func test_enemy_at_base_reduces_health():
	var initial_health = gm.health
	spawner._on_enemy_at_base(25)
	assert_eq(gm.health, initial_health - 25)

# _on_start_wave_button_pressed() starting a wave triggers state changes
func test_start_wave_button_pressed():
	var enemy_type = EnemyType.new()
	var seq = EnemySequence.new()
	seq.amount = 2
	seq.enemy_type = enemy_type
	seq.interval = 0.01
	var wave = Wave.new()
	wave.sequences.append(seq)
	spawner.waves.append(wave)
	# call
	await spawner._on_start_wave_button_pressed()
	assert_true(spawner.wave_running == false, "Wave should finish")
	assert_eq(spawner.wave_count, 1, "Wave count should increase")
	assert_eq(path.get_child_count(), 2, "Enemies should spawn")
