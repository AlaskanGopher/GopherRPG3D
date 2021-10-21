extends KinematicBody

export var speed = 60

var velocity := Vector3()


export (int) var ACCELERATION = 100
export (int) var MAX_SPEED = 25
export (int) var FRICTION = 250
export (int) var GRAVITY = 2
export (int) var TERMINAL_VELOCITY = 12
var airTime := 0.0

func _physics_process(delta):
	var input_vector = Vector3()
	input_vector.x = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
	input_vector.z = Input.get_action_strength("movement_down") - Input.get_action_strength("movement_up")
	input_vector = input_vector.normalized().rotated(Vector3(0,1,0), rotation.y)
	
	if input_vector != Vector3():
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3(), FRICTION * delta)
	if is_on_ceiling():
		print("grounded ", delta)
		airTime = 0
		velocity.y += 2 if Input.action_press("movement_jump") else 0
	else:
		airTime += delta
	velocity.y -= GRAVITY * airTime
	velocity = move_and_slide(velocity);

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(TAU * -event.relative.x/800)
		if (abs(rotation.x + TAU * -event.relative.y/1000) < PI/2):
			$Head.rotate_object_local(Vector3(1, 0, 0), TAU * -event.relative.y/1000)
			$Head.rotation.x = -clamp(-$Head.rotation.x, -0.25*TAU, 0.25*TAU)
