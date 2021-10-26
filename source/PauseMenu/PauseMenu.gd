class_name PauseMenu
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
	
	# Server stuff
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("connected_to_server", self, "_connected_ok")

func _unhandled_key_input(event):
	if event.pressed and event.scancode == KEY_ESCAPE:
		if get_tree().paused:
			unpause()
		else:
			pause()

#Signals

func _on_ReturnButton_pressed():
	unpause()

func _on_QuitButton_pressed():
	get_tree().quit()
	
func _on_ResetButton_pressed():
	get_tree().reload_current_scene()
	unpause()

#Navigating menus

func _on_MultiplayerButton_pressed():
	$"CenterContainer/Main Menu".visible = false
	$CenterContainer/Multiplayer.visible = true

func _on_MultiplayerBackButton_pressed():
	$"CenterContainer/Main Menu".visible = true
	$CenterContainer/Multiplayer.visible = false

#Multiplayer servers

func _connected_ok(var id : int):
	Globals.selfInfo["Username"] = $CenterContainer/Multiplayer/Username.text
	rpc("createPlayer")

func _player_connected(var id : int):
	rpc_id(id, "createPlayer")
	
func _player_disconnected(var id : int):
	Globals.playerInfo.remove(id)

func _on_MultiplayerHostButton_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int($CenterContainer/Multiplayer/Host/Port.text), 5)
	get_tree().network_peer = peer

func _on_MultiplayerJoinButton_pressed():
	var ipArray = $CenterContainer/Multiplayer/Join/IP.text.split(':')
	var peer = NetworkedMultiplayerENet.new()
	peer.join_server(ipArray[0], ipArray[1])
	get_tree().network_peer = peer

remote func createPlayer(var info := Globals.selfInfo):
	var sender : int = get_tree().get_rpc_sender_id()
	Globals.playerInfo[sender] = info
	var player = preload("res://Player/Player.tscn").instance()
	player.set_name(str(sender))
	player.username = info["Username"]
	player.set_network_master(sender)
	call_deferred("add_child", player)
	
	
	
	
	
