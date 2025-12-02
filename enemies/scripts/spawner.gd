extends Node

## A reference to the parent Path2D node.
@export var path: Path2D
 
## A reference to the complete enemy scene.
@export var enemy_scene: PackedScene

## A reference to the array of Wave resources; initially empty.
@export var waves: Array[Wave] = []

@export_category("External Nodes")
## A reference to the wave controller from [HUD].
@export var wave_controller: HUD

## A refernce to the [GameManager].
@export var game_manager: GameManager

## Keeps track of the current wave in the array of waves, 'waves'.
var current_wave_index: int = 0

## Boolean flag to determine if a current wave is running.
var wave_running: bool = false

## Keeps track of how many waves have elapsed.
var wave_count: int = 0

## A signal to indicate that the current wave has finished.
signal wave_finished(has_more_waves: bool)

## Connect signal to 'start wave button' and initialize index/flag.
func _ready() -> void:
	if wave_controller and wave_controller.has_signal("started_wave"):
		wave_controller.started_wave.connect(_on_start_wave_button_pressed)
		wave_finished.connect(wave_controller._on_wave_finished)
	
	current_wave_index = 0
	wave_running = false

## Handles action when UI 'start wave' button has been pressed.
func _on_start_wave_button_pressed() -> void:
	if wave_running:
		return
	
	if current_wave_index >= waves.size():
		wave_finished.emit(false)
		return
		
	wave_running = true
	wave_count += 1
	wave_controller.update_wave_display(wave_count)
		
	var wave: Wave = waves[current_wave_index]
	current_wave_index += 1
	
	await spawn_wave(wave)
	
	wave_running = false
	var has_more = current_wave_index < waves.size()
	wave_finished.emit(has_more)
	
## Method to spawn each sequence of enemies in the array of sequences.
## @param wave: An array of Wave resources
func spawn_wave(wave: Wave) -> void:
	for seq in wave.sequences:
		await spawn_sequence(seq)

## Method to instantiate each enemy resource in the provided sequence of enemies.
## @param seq: EnemySequence resource which indicates quantity and EnemyType enemy.
func spawn_sequence(seq: EnemySequence) -> void:
	for i in range(seq.amount):
		spawn_enemy(seq.enemy_type)
		await get_tree().create_timer(seq.interval).timeout

## Method to add each enemy to the Path2D scene tree.
## @param type: EnemyType that indicates which of the types is to be added as a child to Path2D.
func spawn_enemy(type: EnemyType) -> void:
	if path == null:
		push_error("Spawner has no Path2D; 'path is null.")
		return
	
	var enemy: Enemy = enemy_scene.instantiate()
	path.add_child(enemy)
	enemy.setup(type)
	enemy.progress_ratio = 0.0
	
	enemy.reached_end.connect(_on_enemy_at_base)

func _on_enemy_at_base(damage: int) -> void:
	if game_manager:
		game_manager.remove_health(damage)
