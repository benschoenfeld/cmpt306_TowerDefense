extends GutTest

var BuildBase = preload("res://defenses/base/base.gd")
var base: BuildBase
var tower_instance: TowerInstance

# Mock TowerResource
class MockTowerResource:
	extends TowerResource
	func _init():
		turret_texture = null
		area_range = 32
		bullet_sound = null
		damage = 10
		fire_rate = 1.0
		bullet_speed = 300.0
		bullet_scene = null

func before_each():
	# Create base and tower holder
	base = BuildBase.new()
	var holder = Node2D.new()
	holder.name = "TowerHolder"
	base.add_child(holder)
	base.tower_holder = holder
	get_tree().root.add_child(base)
	base._ready()
	
	# tower instance
	tower_instance = TowerInstance.new()
	
	# avoid _draw() errors
	var mock_res = MockTowerResource.new()
	tower_instance.tower_resource = mock_res
	tower_instance.area = CollisionShape2D.new()
	tower_instance.area.shape = CircleShape2D.new()
	tower_instance.add_child(tower_instance.area)
	
	# fire sound node
	var fire_node = AudioStreamPlayer2D.new()
	fire_node.name = "TowerFire"
	tower_instance.add_child(fire_node)
	
	# tower combat
	var combat_node = Node2D.new()
	combat_node.name = "TowerCombat"
	tower_instance.add_child(combat_node)
	base.tower_holder.add_child(tower_instance)

func after_each():
	if is_instance_valid(base):
		base.queue_free()

func test_ready_adds_to_group_and_sets_meta():
	base._ready()
	assert_true(base.is_in_group("TowerBases"), "Should be in TowerBases group")
	assert_eq(base.get_meta("occupied"), false, "Meta should be false")
