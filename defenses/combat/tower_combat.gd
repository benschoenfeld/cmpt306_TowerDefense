class_name TowerCombat

extends Node2D
## Handles targeting, rotation, and firing logic for a tower.
##
## [TowerCombat] detects enemies within range using an assigned
## [Area2D], chooses a target using [PriorityQueue],
## rotates the turret toward the target, and fires bullets
## using the assigned [PackedScene]
##
## The tower fires based on its fire_rate, and each bullet inherits
## damage, speed, and targeting parameters at moment of fire.

## The bullet scene to instantiate when firing.
@export var bullet_scene: PackedScene

## The number of shots fired per second.
@export var fire_rate: float = 1.0

## The amount of damage each bullet deals.
@export var damage: int = 1

## The speed applied to new bullets.
@export var bullet_speed: float = 600.0

@export var bullet_sound: AudioStreamPlayer

## Path to the turret node that rotates to face enemies.
@export var turret_node_path: NodePath = NodePath("../Turret")

## Path to a [Node2D] bullet spawn position.
@export var marker_node_path: NodePath = NodePath("../Turret/Marker")

## Path to [Area2D] responsible for detecting enemies in range.
@export var area_range_path: NodePath = NodePath("../AreaRange")

## The current selected enemy target, from the queue.
var current_target: Enemy

## A priority queue of enemy targets currently in range.
## Selects highest priority or furthest down the path.
var targets: PriorityQueue = PriorityQueue.new()

## Time left until the next shot can be fired.
var cooldown: float = 0.0

## The rotating turret component.
@onready var _turret := get_node(turret_node_path)

## The marker that defines where bullets spawn.
@onready var _marker := get_node(marker_node_path)

## The area used for enemy detection.
@onready var _areaRange := get_node(area_range_path)

## Connects detection signals from the range area.
func _ready() -> void:
	if _areaRange.has_signal("area_entered"):
		_areaRange.connect("area_entered", Callable(self, "_on_area_entered"))
	if _areaRange.has_signal("area_exited"):
		_areaRange.connect("area_exited", Callable(self, "_on_area_exited"))

## Main combat update loop.
##
## Cooldown timer, removes invalid enemies, selects target,
## rotates tower towards target, fires bullet when ready.
##
## @param delta The time elapsed since last frame.
func _process(delta: float) -> void:
	# Reduce the cooldown
	cooldown = max(0.0, cooldown - delta)
	
	# Remove dead enemies from being the target
	cleanup_targets()
	
	# Choose new nearest target
	var target = choose_target()
	if not target:
		return
	
	# Rotate tower turrent towareds the enemy smoothly
	_rotate_towards(target)
	
	# Fire if cooldown is up
	if cooldown <= 0.0:
		fire_at(target)
		var rate = max(0.0001, fire_rate)
		cooldown = 1.0 / rate

## Called when an enemy enters the detection radius.
##
## Adds the enemy to the target queue.
##
## @param area The detection area entering entity.
func _on_area_entered(area: Area2D) -> void:
	if not is_instance_valid(area):
		return
	var enemy_node := area.get_parent()
	if enemy_node is Enemy and enemy_node.has_method("do_damage"):
		targets_append_unique(enemy_node)

## Called when an enemy exits the detection radius.
##
## Removes one instance from the target queue.
##
## @param area The detection area exiting entity.
func _on_area_exited(area: Area2D) -> void:
	if not is_instance_valid(area):
		return
	var enemy_node := area.get_parent()
	if enemy_node is Enemy:
		targets_remove()

## Selects and returns the priority enemy from the queue.
func choose_target() -> Enemy:
	return targets.get_max()

## Rotates the turret to face the target enemy.
##
## @param target The enemy to rotate toward.
func _rotate_towards(target: Node2D) -> void:
	if not is_instance_valid(target):
		return
	if _turret and is_instance_valid(_turret):
		_turret.look_at(target.global_position)
	else:
		look_at(target.global_position)

## Fires a bullet at the given enemy target.
##
## Instantiates [member bullet_scene], assigns damage, speed, and target,
## positions it at the marker, and adds it to the active game scene.
##
## @param target The enemy to fire upon.
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
	
	# Determine spawn position
	var spawn_pos := global_position
	if _marker and is_instance_valid(_marker):
		spawn_pos = _marker.global_position
	bullet.global_position = spawn_pos
	
	# Set bullet properties
	if bullet.has_method("set"):
		bullet.set("target", target)
		bullet.set("damage", int(damage))
		bullet.set("speed", float(bullet_speed))
	else:
		if "target" in bullet:
			bullet.target = target
		if "damage" in bullet:
			bullet.damage = damage
		if "speed" in bullet:
			bullet.speed = float(bullet_speed)
	
	# Set initial rotation toward target
	var direction = (target.global_position - spawn_pos)
	if direction.length() > 0:
		bullet.rotation = direction.normalized().angle()
	
	# Add bullet to current scene
	var current_scene = get_tree().get_current_scene()
	if current_scene:
		current_scene.add_child(bullet)
	else:
		get_tree().get_root().add_child(bullet)
	
	bullet_sound.play()

## Adds a unique enemy to the target queue.
##
## @param enemy The enemy instance to add.
func targets_append_unique(enemy: Enemy) -> void:
	targets.insert(enemy)

## Removes the priority enemy from the queue.
func targets_remove() -> void:
	targets.pop()

## Removes invalid enemies from the tracking queue.
func cleanup_targets() -> void:
	for target in targets.queue:
		if not is_instance_valid(target):
			targets.queue.remove_at(targets.queue.find(target))
