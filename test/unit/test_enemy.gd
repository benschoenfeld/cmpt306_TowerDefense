extends GutTest

var enemy_scene = preload("res://enemies/scenes/enemy.tscn")
var enemy: Enemy
var enemy_type: EnemyType

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
	var path = Path2D.new()
	add_child_autofree(path)
	
	# add Path2D for enemy parent
	var curve = Curve2D.new()
	curve.add_point(Vector2(0,0))
	curve.add_point(Vector2(100,0))
	path.curve = curve

	enemy = enemy_scene.instantiate()
	path.add_child(enemy)

# setup()
func test_setup_assigns_health():
	enemy_type = MockEnemyType.new()
	enemy.setup(enemy_type)
	assert_eq(enemy.health, 10)

# do_damage()
func test_do_damage_reduces_health():
	enemy_type = MockEnemyType.new()
	enemy.setup(enemy_type)  # health = 10
	enemy.do_damage(3)
	assert_eq(enemy.health, 7)
	enemy.do_damage(2)
	assert_eq(enemy.health, 5)

# do_damage()
func test_do_damage_triggers_on_death():
	enemy_type = MockEnemyType.new()
	enemy.setup(enemy_type)  # health = 10
	enemy.do_damage(10) # kill enemy
	assert_true(enemy.health <= 0)

# on_death()
func test_on_death_has_die_animation():
	enemy_type = MockEnemyType.new()
	var frames = SpriteFrames.new()
	frames.add_animation("die")
	enemy_type.frames = frames
	enemy.setup(enemy_type)  # health = 10
	enemy.do_damage(10) # kill enemy
	# check updated animation from on_death()
	assert_true(enemy.animation.sprite_frames.has_animation("die"))
