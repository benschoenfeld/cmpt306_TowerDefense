extends Area2D
class_name Bullet

@export var speed: float = 600.0
@export var damage: int = 1

var target: Node = null

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		queue_free()
		return
		
	var direction = target.global_position - global_position
	var distance = direction.length
	
	if distance <= 6.0:
		_hit_target()
		return
		
		
	var velocitY = direction.normalized() * speed * delta
	global_position += velocitY
	rotation = velocitY.angle()
	
func _hit_target() -> void:
	if target and is_instance_valid(target) and target.has_method("do_damage"):
		target.do_damage(damage)
	queue_free()
