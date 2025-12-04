extends Node2D
class_name TowerInstance

@export var turret_path : NodePath = NodePath("Turret/Sprite")
@export var marker_path : NodePath = NodePath("Turret/Marker")
@export var range_area_path: NodePath = NodePath("AreaRange")
@export var tower_combat_path: NodePath = NodePath("TowerCombat")

@export var area: CollisionShape2D

var tower_resource: TowerResource = null 

func _set_resource(towerRes: TowerResource) -> void:
	tower_resource = towerRes

func apply_tower_resource(towerRes: TowerResource) -> void:
	if towerRes == null:
		print("ToweriNstance.apply_tower_resource -> resource is NULL")
		return
	tower_resource = towerRes
	
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

	area.shape = CircleShape2D.new()
	area.shape.radius = towerRes.area_range

	var towerCombat = get_node(tower_combat_path)
	if towerCombat:
		towerCombat.set("damage", int(towerRes.damage))
		towerCombat.set("fire_rate", float(towerRes.fire_rate))
		if towerRes.bullet_scene:
			towerCombat.bullet_scene = towerRes.bullet_scene
		towerCombat.set("bullet_speed", float(towerRes.bullet_speed))
	else:
		print("TowerInstance: towercombat path not found")
	
	if not is_in_group("Towers"):
		add_to_group("Towers")
		
	queue_redraw()

#
func _draw():
	draw_circle(Vector2.ZERO, tower_resource.area_range, Color(1.0, 1.0, 1.0, 0.49), false, 2, true)
