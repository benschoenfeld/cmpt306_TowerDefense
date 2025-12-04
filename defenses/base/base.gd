extends BaseTile
class_name BuildBase

##
@export var tower_instance_scene: PackedScene = preload("res://defenses/towerInstance/tower_instance.tscn")

##
@onready var tower_holder: Node2D = $TowerHolder

func _ready() -> void:
	add_to_group("TowerBases")
	set_meta("occupied", false)

##
func set_tower(new_tower: TowerResource):
	if tower_holder.get_children().size() > 0:
		var current_tower: TowerInstance = tower_holder.get_child(0)
		current_tower.apply_tower_resource(new_tower)
	else:
		var tower_instance = tower_instance_scene.instantiate()
		if tower_instance.has_method("apply_tower_resource"):
			tower_instance.apply_tower_resource(new_tower)
			tower_holder.add_child(tower_instance)
		else:
			print("TowerInstance has no apply_tower_resource method -> Incorrect assigned?")
