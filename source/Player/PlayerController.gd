extends KinematicBody

export var MAX_HEALTH            : float = 100
export var THIRD_PERSON_DISTANCE : float = 5
export var WALKING_ACCELERATION  : float = 100
export var RUNNING_ACCELERATION  : float = 160
export var MAX_WALKING_SPEED     : float = 25
export var MAX_RUNNING_SPEED     : float = 40
export var FRICTION              : float = .1
export var DRAG                  : float = .1
export var GRAVITY               : float = 2
export var TERMINAL_VELOCITY     : float = 12
export var JUMP_STRENGTH         : float = 30

var hp := MAX_HEALTH

var velocity := Vector3()
var airTime := 0.0

func _ready():
	$HUD.MAX_HEALTH = MAX_HEALTH
	$Head/RayCast.add_exception(self)
	$Head/RayCast.cast_to.z = THIRD_PERSON_DISTANCE
	$Head/ThirdPerson.translation.z = THIRD_PERSON_DISTANCE

func _process(_delta):
	if $Head/RayCast.get_collider() != null:
		var distance = $Head.global_transform.origin.distance_to($Head/RayCast.get_collision_point())
		$Head/ThirdPerson.translation.z = distance
	else:
		$Head/ThirdPerson.translation.z = THIRD_PERSON_DISTANCE
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		$Sword.translation.z = -.75
	else:
		$Sword.translation.z = -.25

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
		
		if Input.is_action_pressed("movement_jump"):
			acceleration.y += JUMP_STRENGTH
	else:
		airTime += delta
		
		acceleration.x -= velocity.x * DRAG
		acceleration.z -= velocity.z * DRAG
	
	acceleration.y -= GRAVITY * airTime
	velocity += acceleration
	velocity = move_and_slide(velocity, Vector3(0, 1, 0));

func _input(event):
	if event is InputEventMouseButton:
		if (event.button_index == BUTTON_LEFT) and event.pressed:
			$Sword.swing()
	elif event is InputEventMouseMotion:
		rotate_y(TAU * -event.relative.x/800)
		if (abs(rotation.x + TAU * -event.relative.y/1000) < PI/2):
			$Head.rotate_object_local(Vector3(1, 0, 0), TAU * -event.relative.y/1000)
			$Head.rotation.x = -clamp(-$Head.rotation.x, -0.25*TAU, 0.25*TAU)

