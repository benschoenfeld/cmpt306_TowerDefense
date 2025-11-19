extends PathFollow2D
class_name Enemy

@export var type: EnemyType

var health: int

@onready var animation: AnimatedSprite2D = $Frames
