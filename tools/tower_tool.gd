class_name TowerTool

extends ToolBase
## Part of a strategy pattern with the [ToolManager].
##
## Interacts with a [BuildBase] and a [TowerResource] in it.

## Emits change the money has changed when a player buys a tower.
signal money_changed(new_amount: int)

## Emits when a player cannot buy a tower.
signal denied_tower()

## A [TowerResource] that will be applied to a [TowerInstance].
var selected_tower: TowerResource

## The current money the player has.
var money_amount: int

## A reference to a [AudioStreamPlayer] that will play when a player does not have enough money.
@onready var deny_sound: AudioStreamPlayer = $DenySound

## Puts the [param selected_tower] into a [TowerInstance]. Or does nothing and 
## emits a [signal denied_tower] to say the player has not placed a tower.
func interact_effect(tile: BaseTile):
	#check money
	if selected_tower:
		if not _can_afford_a_tower(selected_tower.get_cost()):
			deny_sound.play()
			print("Not enough moeny for: ", selected_tower.tower_name, " cost:", selected_tower.cost)
			denied_tower.emit()
			return
		
		if tile is BuildBase:
			
			tile.set_meta("occupied", true)
			tile.set_tower(selected_tower)
		
			_buy_tower(selected_tower.get_cost())
		
			sound_player.play()

## A setter for [param select_tower].
func set_tower(new_tower: TowerResource) -> void:
	selected_tower = new_tower

## A setter for [param money_amount].
func set_money_amount(new_amount: int) -> void:
	money_amount = new_amount

## A private function to calculate if the player has enought money to 
## buy a tower.
func _can_afford_a_tower(cost: int) -> bool:
	return money_amount >= cost

## A private function that sends out [signal money_changed].
func _buy_tower(cost: int) -> void:
	money_changed.emit(cost)
