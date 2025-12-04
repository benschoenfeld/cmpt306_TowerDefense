class_name GameManager

extends Node
## This is the scene that puts together game machanics.
##
## Connects the [FarmingTiles] with the [ToolManager]
## and holds the [param money_amount] for other parts of the game
## to use. Pseudo global node.

## Emits the new amount of money.
signal money_changed(new_amount: int)

## Emits the new amount of health.
signal health_change(new_amount: int)

@export_category("GameManager Nodes")
## A reference to a [PauseMenu].
@export var pause_menu: PauseMenu

## A reference to a [CanvasLayer].
@export var pause_ui_canvas: CanvasLayer

## A reference to the [TileMapLayer] that holds the [FarmingTile].
@export var game_map_tile_map: TileMapLayer

## A reference to the [ToolManager] to interact with [FarmingTile].
@export var tool_manager: ToolManager

## A reference to the an [AudioStreamPlayer] that will play a money sound 
## when the money is changed.
@export var money_sound_player: AudioStreamPlayer

@export var background_music: AudioStreamPlayer

@export var battle_music: AudioStreamPlayer

@export_category("Game Settings")
## The players resource.
@export var money_amount: int = 100

## The players health resource.
@export var health_amount: int = 20

## A reference to the model that holds interactable game objects.
@onready var model: Model = Model.new()

## Sets up the all the interactable game tiles
func _ready() -> void:
	Engine.time_scale = 5 #TODO: REMOVE
	set_health(health_amount)
	set_money(money_amount)
	_set_up_model()
	# Give information to the tool manager to allow player 
	# to interact with tiles.
	tool_manager.set_tile_map(game_map_tile_map)
	tool_manager.set_model(model)

## Sets the [param money_amount] and emits a signal.
func set_money(new_amount: int) -> void:
	# Play audio for money being collected
	money_sound_player.play()
	money_amount = new_amount
	money_changed.emit(money_amount)


## Adds to the [param money_amount].
func add_money(new_amount: int) -> void:
	set_money(get_money() + new_amount)

## Returns the [param money_amount]
func get_money() -> int:
	return money_amount

## Takes away an [int] amount of health from the [param health_amount].
func remove_health(damage: int) -> void:
	set_health(get_health() - damage)
	if health_amount <= 0:
		_player_death()

## Set an [int] amount for the [param health_amount].
func set_health(amount: int) -> void:
	health_amount = amount
	health_change.emit(health_amount)

## Returns the [param health_amount].
func get_health() -> int:
	return health_amount

## Return the [param model].
func get_model() -> Model:
	return model

func switch_music(battle_mode: bool) -> void:
	if battle_mode:
		background_music.volume_linear = 0
		battle_music.play()
	else:
		battle_music.stop()
		background_music.volume_db = 0

## A private function to handle the death of the player and issue a game over.
func _player_death() -> void:
	print("Death")
	var game_over_scene: PackedScene = preload("res://general_ui/game_over/game_over_ui.tscn")
	var game_over: GameOverUI = game_over_scene.instantiate()
	pause_ui_canvas.add_child(game_over)
	get_tree().paused = true

## A private function to handle the win of the player.
func _player_wins() -> void:
	print("Win")
	var winning_scene: PackedScene = preload("res://general_ui/winning_scene/winning_scene.tscn")
	var winning: WinningScene = winning_scene.instantiate()
	pause_ui_canvas.add_child(winning)
	get_tree().paused = true

## A private funtion to handle the making and conenction of the [param model].
func _set_up_model() -> void:
	game_map_tile_map.update_internals()
	model.create_dict(game_map_tile_map)

## When the pause button is pressed is adds the pause scene to 
## the [param pause_menu_layer].
func _on_pause_button_pressed() -> void:
	pause_menu.set_pause(true)


func _on_spawner_wave_finished(has_more_waves: bool) -> void:
	if !has_more_waves:
		_player_wins()
	tool_manager.set_inactive(true)
	switch_music(false)
