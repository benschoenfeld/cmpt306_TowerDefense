extends BaseTile
class_name BuildBase

func _ready() -> void:
	add_to_group("TowerBases")
	set_meta("occupied", false)
