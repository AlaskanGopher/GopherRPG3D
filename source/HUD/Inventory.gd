extends Control

export var SLOT_SIZE : float = 64

var selectedCell : Vector3 = Vector3(-1, 0, 0) # Vector3(0: Inventory; 1: Hotbar, rowNumber (y), colNumber (x)

func _ready():
	$VBoxContainer/Hotbar.resize(SLOT_SIZE)
	$VBoxContainer/InventoryGrid.resize(SLOT_SIZE)

func _process(_delta):
	if Input.is_action_just_pressed("menu_inventory"):
		visible = !visible
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if visible else Input.MOUSE_MODE_CAPTURED)
	if !visible:
		return
	var mousePosition : Vector2 = get_global_mouse_position()
	for slot in $VBoxContainer/InventoryGrid.get_children():
		var slotBounds : Rect2 = slot.get_global_rect()
		if (slotBounds.has_point(mousePosition)):
			var splitName = slot.name.split(',')
			selectedCell = Vector3(0, int(splitName[0][-1]), int(splitName[1][0]))
			print(splitName[0][-1], ' ', splitName[1][0])
			break
	for slot in $VBoxContainer/Hotbar.get_children():
		var slotBounds : Rect2 = slot.get_global_rect()
		if (slotBounds.has_point(mousePosition)):
			selectedCell = Vector3(1, 0, int(slot.name[-1]))
			print(selectedCell)
			break
