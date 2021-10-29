extends HBoxContainer

export var SLOTS : int = 6

func _ready():
	rect_size.x = SLOTS*64
	rect_position.x = get_parent().rect_size.x - rect_size.x
	for i in range(SLOTS):
		var slot := NinePatchRect.new()
		slot.name = "Slot" + str(i)
		print(slot.name)
		slot.texture = preload("res://Resources/Hotbar/Hotbar.png")
		slot.size_flags_horizontal = SIZE_EXPAND_FILL
		slot.size_flags_vertical   = SIZE_EXPAND_FILL
		if i == 0:
			slot.region_rect = Rect2(0, 0, 32, 32)
		elif i == SLOTS-1:
			slot.region_rect = Rect2(32, 0, 32, 32)
		else:
			slot.region_rect = Rect2(64, 0, 32, 32)
		add_child(slot)
