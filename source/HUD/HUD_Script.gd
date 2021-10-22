extends CanvasLayer

export (int) var HEALTH = 100

func _process(_delta):
	$Control/Health.text = str("Health: ", HEALTH)
