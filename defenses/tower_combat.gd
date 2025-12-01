extends Node2D
class_name TowerCombat

@export var bullet_scene: PackedScene
@export var fire_rate: float = 1.0
@export var damage: int = 1
@export var bullet_speed: float = 600.0

@export var turret_node_path: NodePath = NodePath("../Turret")
@export var marker_node_path: NodePath = NodePath("../Turret/Marker")
@export var area_range_path: NodePath = NodePath("../AreaRange")

var targets: Array = []
var cooldown: float = 0.0

@onready var _turret := get_node(turret_node_path)
@onready var _marker := get_node(marker_node_path)
@onready var _areaRange := get_node(area_range_path)


func _ready() -> void:
	if _areaRange.has_signal("area_entered"):
		_areaRange.connect("area_entered", Callable(self, "_on_area_entered"))
	if _areaRange.has_signal("area_exited"):
		_areaRange.connect("area_exited", Callable(self, "_on_area_exited"))

func _process(delta: float) -> void:
	cooldown = max(0.0, cooldown - delta)
	cleanup_targets()
	var target = choose_target()
	if target:
		_rotate_towards(target)
		fire_at(target)
		cooldown = 1.0 / max(0.0001, fire_rate)
	

func _on_area_entered(area: Area2D) -> void:
	if not is_instance_valid(area):
		return
	var enemy_node := area.get_parent()
	if enemy_node and enemy_node.has_method("do_damage"):
		targets_append_unique(enemy_node)
	

func _on_area_exited(area: Area2D) -> void:
	if not is_instance_valid(area):
		return
	var enemy_node := area.get_parent()
	if enemy_node:
		targets_remove(enemy_node)

func choose_target() -> Node2D:
	var enemy_target = null
	var best_target := INF
	for target in targets:
		if not is_instance_valid(target):
			continue
		var distanceToEnemy = global_position.distance_to(target.global_position)
		if distanceToEnemy < best_target:
			best_target = distanceToEnemy
			enemy_target = target
	return enemy_target

func _rotate_towards(target: Node2D) -> void:
	if not is_instance_valid(target):
		return
	if _turret and is_instance_valid(_turret):
		_turret.look_at(target.global_position)
	else:
		look_at(target.global_position)

func fire_at(target: Node2D):
	if bullet_scene == null:
		push_error("TowerCombat.gd: bullet scene not assigned")
		return
	if not is_instance_valid(target):
		return
	var bullet = bullet_scene.instantiate()
	if bullet == null:
		push_error("Failed to instantiate bullet scene in TowerCommbat")
		return
		
	var spawn_pos := global_position
	if _marker and is_instance_valid(_marker):
		spawn_pos = _marker.global_position
	bullet.global_position = spawn_pos
	bullet.set("target", target)
	bullet.set("damage", int(damage))
	
	if bullet.has_method("set"):
		bullet.set("speed", float(bullet_speed))
		bullet.set("bullet_speed", float(bullet_speed))
	var direction = (target.global_position - spawn_pos)
	if direction.length() > 0:
		bullet.rotation = direction.normalized().angle()
	
	var current_scene = get_tree().get_current_scene()
	if current_scene:
		current_scene.add_child(bullet)
	else:
		get_tree().get_root().add_child(bullet)
	
func targets_append_unique(node: Node) -> void:
	if node == null:
		return
	for target in targets:
		if target == node:
			return
	
	targets.append(node)
	
func targets_remove(node: Node) -> void:
	for i in range(targets.size()):
		if targets[i] == node:
			targets.remove_at(i)
			return

func cleanup_targets() -> void:
	for i in range(targets.size() -1 , -1, -1):
		if not is_instance_valid(targets[i]):
			targets.remove_at(i) 
