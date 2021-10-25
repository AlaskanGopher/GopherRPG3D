extends Control

var image = Image.new()

export var SLOTS : int = 2
var selected = 1

func _ready():
	image.load("res://Resources/Hotbar/Hotbar.png")
	rect_size.x = SLOTS * 32
	for i in range(SLOTS):
		var slot := TextureRect.new()
		slot.texture = ImageTexture.new()
		slot.rect_size = Vector2(32, 32)
		slot.rect_scale = Vector2(2, 2)
		if i == 0:
			print(slot)
			slot.texture = slot.texture.create_from_image(image.get_rect(Rect2(0, 0, 32, 32)))
		elif i == SLOTS - 1:
			pass
		else:
			pass
		add_child(slot)
