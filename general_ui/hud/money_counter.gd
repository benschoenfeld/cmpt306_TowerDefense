extends Control

var min_val = 0
var max_val = 99999

func _on_game_manager_money_changed(new_amount: int) -> void:
	$Number.text = str(new_amount)
