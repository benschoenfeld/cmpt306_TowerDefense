extends BaseTile
class_name BuildBase

##
@onready var tower_holder: Node2D = $TowerHolder

func _ready() -> void:
	add_to_group("TowerBases")
	set_meta("occupied", false)

##
func set_tower(new_tower: TowerInstance):
	tower_holder.add_child(new_tower)
