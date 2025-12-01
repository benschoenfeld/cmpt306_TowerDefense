extends Node

@export var path: Path2D
 
@export var enemy_scene: PackedScene

@export var waves: Array[Wave] = []


func _ready() -> void:
	start_waves()
	
func start_waves() -> void:
	await spawn_all_waves()
	
func spawn_all_waves() -> void:
	for wave in waves:
		await spawn_wave(wave)
		var pause = wave.delay
		if pause > 0.0:
			await get_tree().create_timer(pause).timeout
			
func spawn_wave(wave: Wave) -> void:
	for seq in wave.sequences:
		await spawn_sequence(seq)
			
func spawn_sequence(seq: EnemySequence) -> void:
	for i in range(seq.amount):
		spawn_enemy(seq.enemy_type)
		await get_tree().create_timer(seq.interval).timeout


func spawn_enemy(type: EnemyType) -> void:
	#if path == null:
		#push_error("Spawner has no Path2D; 'path is null.")
		#return
	
	var enemy: Enemy = enemy_scene.instantiate()
	path.add_child(enemy)
	enemy.setup(type)
	enemy.progress_ratio = 0.0
	

	
func _on_enemy_at_base(damage: int) -> void:
	# base_hp -= damage
	#if base_hp <= 0:
		#game_over()
	pass
	
