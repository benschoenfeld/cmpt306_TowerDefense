extends Resource
class_name DefenseResource

@export var defense_name: String = ""
@export var defense_scene: PackedScene
@export var icon: Texture2D
@export var cost: int = 0

func get_cost() -> int:
	return cost
