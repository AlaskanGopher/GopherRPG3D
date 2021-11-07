extends Control

export var MAX_HEALTH : int = 100

var hp : int = MAX_HEALTH
var stamina := 1.0
var selectedSlot = 1

signal switchHeldItem(item)
func _ready():
	$SelectedSlot.rect_position.x = $Hotbar.get_global_rect().position.x + selectedSlot * 64
func _process(_delta):
	$"HP Bar/Label".text = str(hp, '/', MAX_HEALTH)
	$"HP Bar/BarContainer/InnerBar".rect_scale.x = float(hp)/float(MAX_HEALTH)
	$"Stamina Bar/BarContainer/InnerBar".rect_scale.x = stamina

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				print(get_global_mouse_position())
			elif event.button_index == BUTTON_WHEEL_DOWN:
				pass
	if event is InputEventKey:
		if event.scancode >= KEY_0 and event.scancode <= KEY_9 and event.pressed:
			selectedSlot = event.scancode - KEY_1
			selectedSlot = 9 if selectedSlot == -1 else selectedSlot
			$Hotbar.selectedSlot = selectedSlot
			$SelectedSlot.rect_position.x = $Hotbar.get_global_rect().position.x + selectedSlot * 64

func _on_Inventory_opened():
	$Hotbar.visible = false
	$SelectedSlot.visible = false
	$Reticle.visible = false

func _on_Inventory_closed():
	$Hotbar.visible = true
	$SelectedSlot.visible = true
	$Reticle.visible = true

func prompt(var button : int):
	var switch = {
		BUTTON_RIGHT: showPrompt(preload("res://Resources/Input Prompts/MouseInputs.png"), Rect2(0, 0, 32, 32))
	}
	switch.get(button)

func showPrompt(var texture : Texture, var rect : Rect2):
	$ButtonPrompt.visible = true
	$ButtonPrompt.texture = texture
	$ButtonPrompt.region_rect = rect
