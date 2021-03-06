extends Control

func pause():
	get_tree().paused = true
	self.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func unpause():
	get_tree().paused = false
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready():
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_ReturnButton_pressed():
	unpause()

func _on_QuitButton_pressed():
	get_tree().quit()
	
func _on_ResetButton_pressed():
	assert(get_tree().reload_current_scene() == OK)
	unpause()

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_ESCAPE:
		if get_tree().paused:
			unpause()
		else:
			pause()

func _on_OptionsButton_pressed():
	$CenterContainer/MainMenu.visible = false
	$CenterContainer/OptionsMenu.visible = true


func _on_OptionsBackButton_pressed():
	$CenterContainer/MainMenu.visible = true
	$CenterContainer/OptionsMenu.visible = false
