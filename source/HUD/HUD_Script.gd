extends Control

export var MAX_HEALTH : int = 100

var hp : int = MAX_HEALTH
var stamina := 1.0

func _process(_delta):
	$"HP Bar/Label".text = str(hp, '/', MAX_HEALTH)
	$"HP Bar/BarContainer/InnerBar".rect_scale.x = float(hp)/float(MAX_HEALTH)
	$"Stamina Bar/BarContainer/InnerBar".rect_scale.x = stamina
