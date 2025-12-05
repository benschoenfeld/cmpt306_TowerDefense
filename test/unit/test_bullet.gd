extends GutTest

var Bullet := preload("res://defenses/bullets/bullet.gd")
var bullet: Bullet
var target: Node2D

# Mock Enemy
class MockEnemy:
	extends Node2D
	var damage_taken := 0
	func do_damage(amount): damage_taken += amount

# Mock Area2D
class MockArea2D:
	extends Area2D

func before_each():
	bullet = Bullet.new()
	bullet.global_position = Vector2.ZERO
	add_child_autofree(bullet)

# Bullet moves straight when no target is set
func test_bullet_moves_straight_without_target():
	var initial_pos = bullet.global_position
	bullet.rotation = 0  # faces right
	bullet._process(1.0)  # 1 second
	assert_true(bullet.global_position.x > initial_pos.x, "Bullet should move right")

# Bullet tracks target when follow_enemy is true
func test_bullet_tracks_target():
	var target = Node2D.new()
	target.global_position = Vector2(200, 0)
	add_child_autofree(target)

	bullet.target = target
	bullet.follow_enemy = true

	bullet._process(0.5)

	assert_true(bullet.global_position.x > 0, "Bullet should move toward target")

# Bullet hits target when close enough
func test_bullet_hits_target_and_frees():
	var enemy = MockEnemy.new()
	add_child_autofree(enemy)

	# place enemy within HIT_DISTANCE
	enemy.global_position = Vector2(5, 0)
	bullet.target = enemy

	var was_freed_before = bullet.is_queued_for_deletion()

	bullet._process(0.1)

	assert_true(enemy.damage_taken == bullet.damage, "Bullet should deal damage")
	assert_true(bullet.is_queued_for_deletion(), "Bullet should queue_free after hit")
	assert_false(was_freed_before, "Bullet should not be freed before processing")

# Bullet expires after max_lifetime
func test_bullet_expires_after_lifetime():
	bullet.max_lifetime = 1.0
	bullet.lifetime = 0.99

	bullet._process(0.1)

	assert_true(bullet.is_queued_for_deletion(), "Bullet should expire after lifetime")

# _on_area_entered assign target and hits
func test_area_entered_assigns_target_and_hits():
	var enemy = MockEnemy.new()
	var area = MockArea2D.new()
	add_child_autofree(enemy)
	enemy.add_child(area)
	
	var initial_damage = enemy.damage_taken
	bullet._on_area_entered(area)
	assert_true(enemy.damage_taken > initial_damage, "Enemy should receive damage")
	assert_true(bullet.is_queued_for_deletion(), "Bullet should queue_free after hit")
