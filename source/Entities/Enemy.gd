extends KinematicBody

export var GRAVITY : float = 1
export var MAX_HEALTH : int = 100
var velocity : Vector3 = Vector3()
var airTime = 0;
var hp: int = MAX_HEALTH

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		onHealthChange(-1)
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
	$"Viewport/HP Bar/InnerBar".rect_scale.x = float(hp)/float(MAX_HEALTH)
	$"Viewport/HP Bar/Label".text = str(hp)+"/"+str(MAX_HEALTH)
