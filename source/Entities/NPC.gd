extends KinematicBody

export var GRAVITY : float = 1
export var MAX_HEALTH : int = 100
var velocity : Vector3 = Vector3()
var airTime = 0;


func _physics_process(delta):
	var acceleration = Vector3()
	if is_on_floor():
		airTime = 0
	else:
		airTime += delta
	acceleration.y -= GRAVITY * airTime
	velocity += acceleration
	move_and_slide(velocity, Vector3(0, 1, 0))

func _process(_delta):
	var head = get_viewport().get_camera().get_parent_spatial()
	$HUDObject.rotation = head.rotation + head.get_parent_spatial().rotation
