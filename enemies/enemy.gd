extends PathFollow2D
class_name Enemy

@export var type: EnemyType

var health: int

@onready var animation: AnimatedSprite2D = $Frames

signal reached_end(damage: int)

func _ready() -> void:
	health = type.health
	
	animation.sprite_frames = type.frames
	
	if animation.sprite_frames != null:
		animation.play(animation.sprite_frames.get_animation_names()[0])
		
	progress_ratio = 0.0
	
func _process(delta: float) -> void:
	progress += type.speed * delta
	
	if progress_ratio >= 1.0:
		emit_signal("reached_goal", type.damage)
		queue_free()
	
func do_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		on_death()

func on_death() -> void:
	if animation.sprite_frames and animation.sprite_frames.has_animation("die"):
		animation.play("die")
		await animation.animation_finished
	queue_free()
