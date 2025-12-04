extends Area2D
class_name Bullet

## A bullet fired by  the towers that moves toward a target and deals damage.
##
## The [Bullet] travels either in a line or by tracking a target.
## It destroys itself after an amount of time or when it hits an enemy.

## The speed the bullet travels in pixels per second.
@export var speed: float = 600.0

## The amount of damage dealt when the bullet hits an enemy.
@export var damage: int = 1

## If true, the bullet will rotate and move towards the target.
## NOT in a straight line
@export var follow_enemy: bool = true

## The maximum time in seconds the bullet can exist.
@export var max_lifetime: float = 6.0

## The enemy the bullet tracks or collides with.
var target: Node = null

## Reference to the node that spawned the bullet.
var owner_target: Node = null

## The distance within the target the bullet needs to reach to count as a hit.
const HIT_DISTANCE: float = 8.0

## The time the bullet has been alive.
var lifetime: float = 0.0

func _ready() -> void:
	pass

## Main logic loop. Moves bullet, tracks lifetime and handles hits.
##
## @param delta The time elapsed since last frame.
func _process(delta: float) -> void:
	lifetime += delta
	if lifetime >= max_lifetime:
		queue_free() # Removes bullet from scene
		return
	
	# If no valid target, move bullet straight
	if target == null or not is_instance_valid(target):
		global_position += Vector2(cos(rotation), sin(rotation)) * speed * delta
		return
	
	# Direction and distance toward target
	var direction = (target.global_position - global_position)
	var distance = direction.length()
	
	# Hit detection
	if distance <= HIT_DISTANCE:
		hit_target()
		return
	
	# Following target movement
	if follow_enemy:
		var velocity = direction.normalized() * speed
		global_position += velocity * delta
		if velocity.length() > 0:
			rotation = velocity.angle()
	
	# Move bullet straight 
	else:
		global_position += Vector2(cos(rotation), sin(rotation)) * speed * delta

## Called when the bullet enters another [Area2D].
##
## If collided area belongs to enemy that has .do_damage() method,
## the bullet will apply its damage and remove itself.
##
## @param area The area the bullet overlapped.
func _on_area_entered(area: Area2D) -> void:
	if not is_instance_valid(area):
		return
	var enemY = area.get_parent()
	if enemY and enemY.has_method("do_damage"):
		target = enemY
		hit_target()

## Deals damage to the current target and destroys the bullet.
##
## The bullet checks if the target is still valid and has .do_damage() method
## before applying damage.
func hit_target() -> void:
	if target != null and is_instance_valid(target) and target.has_method("do_damage"):
		target.do_damage(damage)
		
	queue_free()
