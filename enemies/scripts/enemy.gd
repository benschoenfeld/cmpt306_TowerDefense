extends PathFollow2D
class_name Enemy

## A reference to the type of enemy.
@export var type: EnemyType

## A reference to the direct path of the animation for the AnimatedSprite2D.
@onready var animation: AnimatedSprite2D = $Area2D/AnimatedSprite2D

# Determines the health of the player.
var health: int

## A signal that indicates the enemy has completed it's Path2D.
signal reached_end(damage: int)

## Method to initialize the enemy's stats and animations.
## @param enemy_type: EnemyType indicates which resource is being used.
func setup(enemy_type: EnemyType) -> void:
	type = enemy_type
	health = type.health
	
	animation.sprite_frames = type.frames
	
	if animation.sprite_frames != null:
		var move_animation = String(type.walk_animation)
		
		if move_animation != "" and animation.sprite_frames.has_animation(move_animation):
			animation.play(move_animation)
		else:
			var names = animation.sprite_frames.get_animation_names()
			if names.size() > 0:
				animation.play(names[0])
			
	loop = false
	progress_ratio = 0.0
	
## Physics method to control movement of the enemy.
## Increase progress of Path2D by speed*delta.
func _process(delta: float) -> void:
	progress += type.speed * delta
	
	if progress_ratio >= 1.0:
		emit_signal("reached_end", type.damage)
		queue_free()
	
## Method
func do_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		on_death()

func on_death() -> void:
	## The dead enemeis were still following the path so I commented animation for now
	#if animation.sprite_frames and animation.sprite_frames.has_animation("die"):
		#animation.play("die")
		#await animation.animation_finished
	queue_free()
