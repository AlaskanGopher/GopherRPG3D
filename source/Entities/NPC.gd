extends KinematicBody

export var GRAVITY : float = 1
export var MAX_HEALTH : int = 100
var velocity : Vector3 = Vector3()
var airTime = 0;
var hp: int = MAX_HEALTH
var id = "1"

func _physics_process(delta):
	var acceleration = Vector3()
	if is_on_floor():
		airTime = 0
	else:
		airTime += delta
	acceleration.y -= GRAVITY * airTime
	velocity += acceleration
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))

func _process(_delta):
	var head = get_viewport().get_camera().get_parent_spatial()
	$HUDObject.rotation = head.rotation + head.get_parent_spatial().rotation

func onHealthChange(var difference: int):
	hp += difference
	$"Viewport/HP Bar/BarContainer/InnerBar".rect_scale.x = float(hp)/float(MAX_HEALTH)
	$"Viewport/HP Bar/Label".text = str(hp)+"/"+str(MAX_HEALTH)

func playerInteraction(var player : KinematicBody):
	if Input.is_action_just_pressed("object_interact"):
		player.get_node("./HUD/ButtonPrompt").visible = false
		# Read dialogue from file
		var file = File.new()
		file.open("res://Resources/Dialogue/dialogueStory.json", File.READ)
		var resultJson = JSON.parse(file.get_as_text())
		file.close()
		if resultJson.error != OK:
			print("Error: ", resultJson.error)
			print("Error Line: ", resultJson.error_line)
			print("Error String: ", resultJson.error_string)
		var dialogueInfo = resultJson.result[id]
		print(dialogueInfo["name"])
		print(dialogueInfo["color"])
		print(dialogueInfo["text"])
	else:
		player.get_node("./HUD").prompt(BUTTON_RIGHT)
