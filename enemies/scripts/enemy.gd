class_name Enemy

extends PathFollow2D
## The enemy logic.
##
## Holds all of the information needed to interact with enemies.
## Different enemeis come from different [EnemyType] resource files.

## A reference to the type of enemy.
@export var type: EnemyType

## A reference to the direct path of the animation for the AnimatedSprite2D.
@export var animation: AnimatedSprite2D

## Determines the health of the [Enemy].
var health: int

## A signal that indicates the enemy has completed it's Path2D.
signal reached_end(damage: int)

## A signal that emits when the [Enemy] has less than or equal to zero [param health].
signal enemy_death()

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
		on_death()
	
## Method that handle lowering the health of the enemy.
func do_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		on_death()
		
## Method to handle the death of an enemy.
## Handles the death sound that plays until it's finished after the enemy is freed
func on_death() -> void:
	# If the enemy and dying sound exists
	if type != null and type.death_sound != null:
		var d_sound := AudioStreamPlayer2D.new()
		d_sound.stream = type.death_sound
		d_sound.global_position = global_position
		
		# increases the volume
		d_sound.volume_db = 10.0
		
		# Adds the sound scene root so it doesn't get deleted when the enemy is freed
		var root := get_tree().get_current_scene()
		root.add_child(d_sound)
		d_sound.play()
		
		# removed the sound when once the audio has been played
		if d_sound.has_signal("finished"):
			d_sound.connect("finished", Callable(d_sound,"queue_free"))
	enemy_death.emit()
	queue_free()

## Returns the comparision of [member PathFollow2D.progress] to another [Enemy].
## Returns true if self.progress > compare_enemy.progress.
func compare_to(compare_enemy: Enemy) -> bool:
	return self.progress > compare_enemy.progress
