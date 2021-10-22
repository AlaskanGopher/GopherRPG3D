extends CanvasLayer

export (int) var HEALTH = 100

signal update_health

func _process(_delta):
	$Control/Health.text = str("Health: ", HEALTH)


func _ready():
	pass
