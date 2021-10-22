extends KinematicBody

export var speed = 60

var velocity := Vector3()


export (int) var WALKING_ACCELERATION = 100
export (int) var RUNNING_ACCELERATION = 160
export (int) var MAX_WALKING_SPEED = 25
export (int) var MAX_RUNNING_SPEED = 40
export (float) var FRICTION = .1
export (float) var DRAG = .1
export (int) var GRAVITY = 2
export (int) var TERMINAL_VELOCITY = 12
export (int) var JUMP_STRENGTH = 30
var airTime := 0.0
var jumped := false

func _physics_process(delta):
	var acceleration := Vector3()
	
	var input_vector := Vector3()
	input_vector.x = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
	input_vector.z = Input.get_action_strength("movement_down") - Input.get_action_strength("movement_up")
	input_vector = input_vector.normalized().rotated(Vector3(0,1,0), rotation.y)
	if Input.is_action_pressed("movement_run"):
		acceleration += Vector3().move_toward(input_vector * MAX_RUNNING_SPEED, RUNNING_ACCELERATION * delta)
	else:
		acceleration += Vector3().move_toward(input_vector * MAX_WALKING_SPEED, WALKING_ACCELERATION * delta)
	
	if is_on_floor():
		airTime = 0
		
		acceleration.x -= velocity.x * FRICTION
		acceleration.z -= velocity.z * FRICTION
		
		if (Input.is_action_pressed("movement_jump")):
			acceleration.y += JUMP_STRENGTH
	else:
		airTime += delta
		
		acceleration.x -= velocity.x * DRAG
		acceleration.z -= velocity.z * DRAG
	acceleration.y -= GRAVITY * airTime
	velocity += acceleration
	velocity = move_and_slide(velocity, Vector3(0, 1, 0));

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(TAU * -event.relative.x/800)
		if (abs(rotation.x + TAU * -event.relative.y/1000) < PI/2):
			$Head.rotate_object_local(Vector3(1, 0, 0), TAU * -event.relative.y/1000)
			$Head.rotation.x = -clamp(-$Head.rotation.x, -0.25*TAU, 0.25*TAU)
