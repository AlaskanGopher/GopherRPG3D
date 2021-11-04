extends Control

export var MAX_HEALTH : int = 100

var hp : int = MAX_HEALTH
var stamina := 1.0

func _process(_delta):
	$"HP Bar/Label".text = str(hp, '/', MAX_HEALTH)
	$"HP Bar/BarContainer/InnerBar".rect_scale.x = float(hp)/float(MAX_HEALTH)
	$"Stamina Bar/BarContainer/InnerBar".rect_scale.x = stamina

func _on_Inventory_opened():
	$Hotbar.visible = false
	$SelectedSlot.visible = false

func _on_Inventory_closed():
	$Hotbar.visible = true
	$SelectedSlot.visible = true

func prompt(var button : int):
	var switch = {
		BUTTON_RIGHT: showPrompt(preload("res://Resources/Input Prompts/MouseInputs.png"), Rect2(0, 0, 32, 32))
	}
	switch.get(button)

func showPrompt(var texture : Texture, var rect : Rect2):
	$ButtonPrompt.visible = true
	$ButtonPrompt.texture = texture
	$ButtonPrompt.region_rect = rect
