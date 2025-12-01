extends Node2D
class_name TowerInstance

@export var turret_path : NodePath = NodePath("Turret/Sprite")
@export var marker_path : NodePath = NodePath("Turret/Marker")
@export var range_area_path: NodePath = NodePath("AreaRange")
@export var tower_combat_path: NodePath = NodePath("TowerCombat")



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
			
			if turret_sprite.modulate.a == 0:
				turret_sprite.modulate = Color(1, 1, 1, 1)
			if turret_sprite.scale == Vector2.ZERO:
				turret_sprite.scale = Vector2.ONE
		
		else:
			print("TowerInstance: turrent path doesn't point to a sprite2d: ", turret_path)

		
	var areaRange = get_node(range_area_path)
	if areaRange:
		var ColShape = get_node("AreaRange/CollisionShape2D")
		if ColShape and ColShape is CollisionShape2D and ColShape.shape:
			if ColShape is CircleShape2D:
				ColShape.radius = float(towerRes.area_range)
	
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
	
	print("TowerInstance: applied resource:", towerRes.tower_name, "turret_texture:", towerRes.turret_texture, "areaRange: ", towerRes.area_range)
		
	
