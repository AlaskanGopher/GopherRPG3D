extends Control

export var MAX_HEALTH : int = 100

var hp : int = MAX_HEALTH

func _process(_delta):
	$"HP Bar/Label".text = str(MAX_HEALTH, '/', hp)
	$"HP Bar/BarContainer/InnerBar".rect_scale.x = float(hp)/float(MAX_HEALTH)
