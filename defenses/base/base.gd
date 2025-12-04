extends BaseTile
class_name BuildBase

## A tile that holds a placed [TowerInstance].
##
<<<<<<< HEAD
## [BuildBase] represents a buildable tile used for placing towers.
## Towers can be assigned via [method set_tower].

## This internal holder stores an [TowerInstance].
## This provides location for adding and managing towers.
=======
@export var tower_instance_scene: PackedScene = preload("res://defenses/towerInstance/tower_instance.tscn")

##
>>>>>>> 551a199b9832361873c9bd259f907902bc0af7bc
@onready var tower_holder: Node2D = $TowerHolder

## Sets the base tile.
## Adds this node to the "TowerBases" and indicates that no
##tower is currently placed on this base.
func _ready() -> void:
	add_to_group("TowerBases")
	set_meta("occupied", false)

<<<<<<< HEAD
## Places a [TowerInstance] onto this build base.
## attaches [param new_tower] as a child of tower_holder.
## anchors tower visually and logically to the tile.
func set_tower(new_tower: TowerInstance):
	tower_holder.add_child(new_tower)
=======
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
>>>>>>> 551a199b9832361873c9bd259f907902bc0af7bc
