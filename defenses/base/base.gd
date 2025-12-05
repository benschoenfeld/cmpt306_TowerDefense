class_name BuildBase

extends BaseTile
## A tile that holds a placed [TowerInstance].
##
## [BuildBase] represents a buildable tile used for placing towers.
## Towers can be assigned using set_tower, which will update an existing
## tower or on this base create a new one.

## Packed scene used to instantiate a [TowerInstance] if one does not already exist.
@export var tower_instance_scene: PackedScene = preload("res://defenses/towerInstance/tower_instance.tscn")

## This internal holder stores an [TowerInstance].
## This provides location for adding and managing towers.
@onready var tower_holder: Node2D = $TowerHolder

## Sets the base tile.
## Adds this node to the "TowerBases" and marks it as unoccupied.
func _ready() -> void:
	add_to_group("TowerBases")
	set_meta("occupied", false)

## Places or updates a tower on this build base.
##
## Check if tower already exists and updates existing tower or creates new.
##
## @param new_tower A [TowerResource] for updating a tower.
func set_tower(new_tower: TowerResource):
	# If a tower already exists on this base
	if tower_holder.get_children().size() > 0:
		var current_tower: TowerInstance = tower_holder.get_child(0)
		current_tower.apply_tower_resource(new_tower)
	else:
		# No tower exists create a new instance
		var tower_instance = tower_instance_scene.instantiate()
		if tower_instance.has_method("apply_tower_resource"):
			tower_instance.apply_tower_resource(new_tower)
			tower_holder.add_child(tower_instance)
		else:
			print("TowerInstance has no apply_tower_resource method -> Incorrect assigned?")\
