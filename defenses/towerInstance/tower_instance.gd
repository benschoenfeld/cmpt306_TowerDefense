class_name TowerInstance

extends Node2D
## Represents a placed tower, using data from a [TowerResource].
##
## A [TowerInstance] is the instance of a tower.
## It has texture, stats, firing behavior, and range information
## from a [TowerResource] and works with [TowerCombat] to handle
## enemy detection and firing logic.

## Path to turret sprite node to displays the tower.
@export var turret_path : NodePath = NodePath("Turret/Sprite")

## Path to the where bullets will spawn from.
@export var marker_path : NodePath = NodePath("Turret/Marker")

## Path to the [Area2D] used for range detection.
@export var range_area_path: NodePath = NodePath("AreaRange")

## Path to [TowerCombat] script that handles firing.
@export var tower_combat_path: NodePath = NodePath("TowerCombat")

## The collision shape of tower attack radius.
@export var area: CollisionShape2D

## The resource for tower stats, cost, textures, and firing settings.
var tower_resource: TowerResource = null 

## Sets the tower resource.
##
## @param towerRes The [TowerResource] containing the tower’s data.
func _set_resource(towerRes: TowerResource) -> void:
	tower_resource = towerRes

## Applies a [TowerResource] to the tower instance, updating visuals, combat settings,
## and the detection radius.
##
## Updates turret sprite texture, the detection radius based on resource,
## configures the attached [TowerCombat] with damage, fire rate, bullet speed.
## Places the tower into the "Towers" group if not assigned
##
## @param towerRes The [TowerResource] used to configure the tower.
func apply_tower_resource(towerRes: TowerResource) -> void:
	# If resource is null quit
	if towerRes == null:
		print("ToweriNstance.apply_tower_resource -> resource is NULL")
		return
	tower_resource = towerRes
	
	# Turret sprite setup
	var turret_sprite = get_node(turret_path)
	if not turret_sprite:
		turret_sprite = get_node("Turret/Sprite")
	if not turret_sprite:
		turret_sprite = get_node("Sprite")
	if not turret_sprite:
		print("TowerInstance cannot find turret sprite2d, check path", turret_path)
		
	else:
		if turret_sprite is Sprite2D:
			if towerRes.turret_texture:
				turret_sprite.texture = towerRes.turret_texture
			else:
				print("TowerInstance: turrent_texture is not set in the resource -> Keeping default texture")
	
	# Range setup
	area.shape = CircleShape2D.new()
	area.shape.radius = towerRes.area_range
	
	# towers firing a unique bullet sound setup
	var fire_sound := get_node("TowerFire")
	fire_sound.stream = towerRes.bullet_sound
	
	# TowerCombat setup
	var towerCombat = get_node(tower_combat_path)
	if towerCombat:
		towerCombat.set("damage", int(towerRes.damage))
		towerCombat.set("fire_rate", float(towerRes.fire_rate))
		if towerRes.bullet_scene:
			towerCombat.bullet_scene = towerRes.bullet_scene
		towerCombat.set("bullet_speed", float(towerRes.bullet_speed))
	else:
		print("TowerInstance: towercombat path not found")
	
	# Check if tower is in appropriate group
	if not is_in_group("Towers"):
		add_to_group("Towers")
	
	# Redraw the circle if the tower has changed.
	queue_redraw()

## Draws visual representation of tower attack range in the editor.
func _draw():
	draw_circle(Vector2.ZERO, tower_resource.area_range, Color(1.0, 1.0, 1.0, 0.15), false, 2, true)
