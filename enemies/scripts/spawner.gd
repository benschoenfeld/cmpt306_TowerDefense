extends Node

@export var path: Path2D
 
@export var enemy_scene: PackedScene

@export var waves: Array[Wave] = []

@export var wave_controller: Control

var current_wave_index: int = 0
var wave_running: bool = false

signal wave_finished(has_more_waves: bool)

func _ready() -> void:
	if wave_controller and wave_controller.has_signal("started_wave"):
		wave_controller.started_wave.connect(_on_start_wave_button_pressed)
		wave_finished.connect(wave_controller._on_wave_finished)
	
	current_wave_index = 0
	wave_running = false

func _on_start_wave_button_pressed() -> void:
	if wave_running:
		return
	
	if current_wave_index >= waves.size():
		wave_finished.emit(false)
		return
		
	wave_running = true
		
	var wave: Wave = waves[current_wave_index]
	current_wave_index += 1
	
	await spawn_wave(wave)
	
	wave_running = false
	var has_more = current_wave_index < waves.size()
	wave_finished.emit(has_more)
	
			
func spawn_wave(wave: Wave) -> void:
	for seq in wave.sequences:
		await spawn_sequence(seq)
			
func spawn_sequence(seq: EnemySequence) -> void:
	for i in range(seq.amount):
		spawn_enemy(seq.enemy_type)
		await get_tree().create_timer(seq.interval).timeout


func spawn_enemy(type: EnemyType) -> void:
	if path == null:
		push_error("Spawner has no Path2D; 'path is null.")
		return
	
	var enemy: Enemy = enemy_scene.instantiate()
	path.add_child(enemy)
	enemy.setup(type)
	enemy.progress_ratio = 0.0
	

	
func _on_enemy_at_base(damage: int) -> void:
	# base_hp -= damage
	#if base_hp <= 0:
		#game_over()
	pass
	
