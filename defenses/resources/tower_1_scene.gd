extends Node2D
class_name Tower1Fire

@export var bullet_scene: PackedScene
@export var range: float = 200.0
@export var fire_rate: float = 1.0
@export var damage: int = 1
@export var projectile_speed: float = 600.0
@export var rotation_speed: float = 10.0

@onready var tower := get_node("Tower")

var cooldown := 0.0
var target: Node = null

func _process(delta: float) -> void:
	cooldown = max(0.0, cooldown - delta)
	if target and (not is_instance_valid(target) or global_position.distance_to(target.global_position) > range):
		target = null
	
	if target == null:
		target = find_nearest_enemy()
	
	if target:
		if tower:
			tower.look_at(target.global_position)
		else:
			look_at(target.global_position)
			
		if cooldown <= 0.0 and bullet_scene:
			var bullet = bullet_scene.instantiate()
			bullet.global_position = tower.global_position if (tower and is_instance_valid(tower)) else global_position
			bullet.target = target
			bullet.damage = damage
			if "speed" in bullet:
				bullet.speed = projectile_speed
			get_tree().get_current_scene().add_child(bullet)
			cooldown = 1.0/ max(0.0001, fire_rate)

func find_nearest_enemy() -> Node:
	var closest_enemy : Node = null
	var closest_dist := INF
	
	if get_tree().has_group("Enemies"):
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if not is_instance_valid(enemy): continue
			var distToEnemy = global_position.distance_to(enemy.global_position)
			if distToEnemy <= range and distToEnemy < closest_dist:
				closest_enemy = enemy
				closest_dist = distToEnemy
	return closest_enemy
