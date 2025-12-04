extends BaseTile
class_name BuildBase

## A tile that holds a placed [TowerInstance].
##
## [BuildBase] represents a buildable tile used for placing towers.
## Towers can be assigned via [method set_tower].

## This internal holder stores an [TowerInstance].
## This provides location for adding and managing towers.
@onready var tower_holder: Node2D = $TowerHolder

## Sets the base tile.
## Adds this node to the "TowerBases" and indicates that no
##tower is currently placed on this base.
func _ready() -> void:
	add_to_group("TowerBases")
	set_meta("occupied", false)

## Places a [TowerInstance] onto this build base.
## attaches [param new_tower] as a child of tower_holder.
## anchors tower visually and logically to the tile.
func set_tower(new_tower: TowerInstance):
	tower_holder.add_child(new_tower)
