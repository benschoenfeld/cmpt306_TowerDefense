extends Control

var min_val = 0
var max_val = 99999

func _on_hud_money_changed(money):
	$Number.text = str(money)
