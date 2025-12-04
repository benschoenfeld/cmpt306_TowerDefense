class_name TowerTool

extends ToolBase
##
##
##

##
signal money_changed(new_amount: int)

##
var selected_tower: TowerResource

##
var money_amount: int

##
@onready var deny_sound = $DenySound

## 
func interact_effect(tile: BaseTile):
	#check money
	if selected_tower:
		if not _can_afford_a_tower(selected_tower.get_cost()):
			deny_sound.play()
			print("Not enough moeny for: ", selected_tower.tower_name, " cost:", selected_tower.cost)
			return
		
		if tile is BuildBase:
			
			tile.set_meta("occupied", true)
			tile.set_tower(selected_tower)
		
			_buy_tower(selected_tower.get_cost())
		
			sound_player.play()

##
func set_tower(new_tower: TowerResource) -> void:
	selected_tower = new_tower

##
func set_money_amount(new_amount: int) -> void:
	money_amount = new_amount

##
func _can_afford_a_tower(cost: int) -> bool:
	return money_amount >= cost

##
func _buy_tower(cost: int) -> void:
	money_changed.emit(cost)
