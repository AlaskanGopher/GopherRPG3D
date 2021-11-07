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
		var item = Spatial.new()
		item.name = "Empty"
		slot.add_child(item)
		add_child(slot)

func resize(var slotSize : float):
	SLOT_SIZE = slotSize
	rect_min_size.x = SLOTS*SLOT_SIZE
	rect_size.x = SLOTS*SLOT_SIZE
	rect_min_size.y = SLOT_SIZE
	rect_size.y = SLOT_SIZE
