extends HBoxContainer

export var SLOTS     : int = 6
export var SLOT_SIZE : float = 64

var selectedSlot = 0

func _ready():
	rect_min_size.x = SLOTS*SLOT_SIZE
	rect_size.x = SLOTS*SLOT_SIZE
	rect_min_size.y = SLOT_SIZE
	rect_size.y = SLOT_SIZE
	rect_position.x = get_parent().rect_size.x - rect_size.x
	for i in range(SLOTS):
		var slot := NinePatchRect.new()
		slot.name = "Slot" + str(i)
		print(slot.name)
		slot.texture = preload("res://Resources/Hotbar/Hotbar.png")
		slot.size_flags_horizontal = SIZE_EXPAND_FILL
		slot.size_flags_vertical   = SIZE_EXPAND_FILL
		slot.region_rect = Rect2(0, 0, 32, 32)
		add_child(slot)

func _input(event):
	
	# Move this to HUD Script so it doesn't break more stuff
	
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
			get_node("../SelectedSlot").rect_position.x = get_global_rect().position.x + selectedSlot * 64
			print(get_global_rect().position.x +selectedSlot * 64)

func resize(var slotSize : float):
	SLOT_SIZE = slotSize
	rect_min_size.x = SLOTS*SLOT_SIZE
	rect_size.x = SLOTS*SLOT_SIZE
	rect_min_size.y = SLOT_SIZE
	rect_size.y = SLOT_SIZE
