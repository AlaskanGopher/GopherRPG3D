extends GridContainer

export var SLOT_SIZE : float = 64

func _ready():
	rect_min_size.x = columns*SLOT_SIZE
	rect_size.x = columns*SLOT_SIZE
	rect_min_size.y = columns*SLOT_SIZE
	rect_size.y = columns*SLOT_SIZE
	for i in range(columns): # row num
		for j in range(columns): # col num
			var slot := NinePatchRect.new()
			slot.name = str("Slot (", i, ',', j, ')')
			print(slot.name)
			slot.texture = preload("res://Resources/Hotbar/Hotbar.png")
			slot.size_flags_horizontal = SIZE_EXPAND_FILL
			slot.size_flags_vertical   = SIZE_EXPAND_FILL
			if j == 0:
				slot.region_rect = Rect2(0, 0, 32, 32)
			elif j == columns-1:
				slot.region_rect = Rect2(64, 0, 32, 32)
			else:
				slot.region_rect = Rect2(32, 0, 32, 32)
			add_child(slot)

func resize(var slotSize : float):
	SLOT_SIZE = slotSize
	rect_min_size.x = columns*SLOT_SIZE
	rect_size.x = columns*SLOT_SIZE
	rect_min_size.y = columns*SLOT_SIZE
	rect_size.y = columns*SLOT_SIZE
