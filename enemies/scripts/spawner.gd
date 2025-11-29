extends Node

@export var path: Path2D
 
@export var enemy_scene: PackedScene

@export var normal_enemy: EnemyType
@export var fast_enemy: EnemyType
@export var tank_enemy: EnemyType

var waves = [
	{
		"groups": [
			{ "type": "normal", "count": 5, "interval": 1.5 },
		],
		"delay": 15.0,
	},
	{
		"groups": [
			{ "type": "fast", "count": 6, "interval": .75 }
		],
		"delay": 12.0,
	},
	{
		"groups": [
			{ "type": "tank", "count": 6, "interval": 3 }
		],
		"delay": 10.0,
	}
]

func _ready() -> void:
	start_waves()
	
func start_waves() -> void:
	await spawn_all_waves()
	
func spawn_all_waves() -> void:
	for wave in waves:
		await spawn_wave(wave)
		
		var pause = wave.get("delay", 2.0)
		if pause > 0:
			await get_tree().create_timer(pause).timeout
			
func spawn_wave(wave: Dictionary) -> void:
	var groups: Array = wave["groups"]
	
	for group in groups:
		var enemy_type = get_type(group["type"])
		var count: int = group.get("count", 1)
		var interval: float = group.get("interval", 0.5)
		
		for i in range(count):
			spawn_enemy(enemy_type)
			await get_tree().create_timer(interval).timeout
			

func spawn_enemy(enemy_type: EnemyType) -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	
	path.add_child(enemy)
	
	enemy.progress = 0.0
	enemy.progress_ratio = 0.0
	enemy.h_offset = 0.0
	enemy.v_offset = 0.0
	
	enemy.setup(enemy_type)
	
	print()
	
	

func get_type(id: String) -> EnemyType:
	match id:
		"normal":
			return normal_enemy
		"fast":
			return fast_enemy
		"tank":
			return tank_enemy
		_: #fallback so enemy at least has a type
			return normal_enemy

# Rough idea of linking to signal
func _on_enemy_at_base(damage: int) -> void:
	# base_hp -= damage
	#if base_hp <= 0:
		#game_over()
	pass
	
