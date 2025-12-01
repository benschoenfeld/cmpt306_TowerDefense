extends Area2D
class_name Bullet

@export var speed: float = 600.0
@export var damage: int = 1
@export var follow_enemy: bool = true
@export var max_lifetime: float = 6.0

var target: Node = null
var owner_target: Node = null

const HIT_DISTANCE: float = 8.0

var lifetime: float = 0.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	lifetime += delta
	if lifetime >= max_lifetime:
		queue_free()
		return
	
	if target == null or not is_instance_valid(target):
		global_position += Vector2(cos(rotation), sin(rotation)) * speed * delta
		return
	
	var direction = (target.global_position - global_position)
	var distance = direction.length()
	if distance <= HIT_DISTANCE:
		hit_target()
		return
	
	if follow_enemy:
		var velocity = direction.normalized() * speed
		global_position += velocity * delta
		if velocity.length() > 0:
			rotation = velocity.angle()
	
	else:
		global_position += Vector2(cos(rotation), sin(rotation)) * speed * delta
		

func _on_area_entered(area: Area2D) -> void:
	if not is_instance_valid(area):
		return
	var enemY = area.get_parent()
	if enemY and enemY.has_method("do_damage"):
		target = enemY
		hit_target()
	
func hit_target() -> void:
	if target != null and is_instance_valid(target) and target.has_method("do_damage"):
		target.do_damage(damage)
		
	queue_free()
