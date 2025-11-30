extends Resource
class_name TowerResource

@export var tower_name: String = ""
@export var icon: Texture2D
@export var turret_texture: Texture2D

@export var cost: int = 0
@export var damage: int = 1
@export var fire_rate: float = 1.0
@export var area_range: float = 100

@export var bullet_scene: PackedScene
@export var bullet_speed: float = 600.0


func get_cost() -> int:
	return cost
