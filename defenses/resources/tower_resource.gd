extends Resource
class_name TowerResource

@export var tower_name: String = ""
@export var tower_scene: PackedScene
@export var icon: Texture2D
@export var cost: int = 0

func get_cost() -> int:
	return cost
