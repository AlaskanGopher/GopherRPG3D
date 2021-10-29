extends KinematicBody

export var MAX_HEALTH            : int = 100
export var THIRD_PERSON_DISTANCE : float = 5
export var WALKING_ACCELERATION  : float = 100
export var RUNNING_ACCELERATION  : float = 160
export var MAX_WALKING_SPEED     : float = 25
export var MAX_RUNNING_SPEED     : float = 40
export var RUNNING_STAMINA       : float = .1
export var STAMINA_REGEN_TIME    : float = 2
export var FRICTION              : float = .1
export var DRAG                  : float = .1
export var GRAVITY               : float = 2
export var TERMINAL_VELOCITY     : float = 12
export var JUMP_STRENGTH         : float = 30
export var FALL_DAMAGE_THRESHOLD : float = 75

var hp := MAX_HEALTH
var stamina := 1.0
var staminaCooldown := 0.0

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
		if stamina > 0:
			acceleration += Vector3().move_toward(input_vector * MAX_RUNNING_SPEED, RUNNING_ACCELERATION * delta)
			stamina = clamp(stamina - (RUNNING_STAMINA * delta) * abs(Input.get_action_strength("movement_down") - Input.get_action_strength("movement_up")), 0, 1)
			if stamina != $HUD.stamina: staminaCooldown = 0.0
		else:
			stamina = -1
	else:
		acceleration += Vector3().move_toward(input_vector * MAX_WALKING_SPEED, WALKING_ACCELERATION * delta)
		
	if is_on_floor():
		airTime = 0
		acceleration.x -= velocity.x * FRICTION
		acceleration.z -= velocity.z * FRICTION
		acceleration.y -= .0001
		if Input.is_action_pressed("movement_jump") and velocity.y < 1:
			acceleration.y += JUMP_STRENGTH
	else:
		airTime += delta
		acceleration.x -= velocity.x * DRAG
		acceleration.z -= velocity.z * DRAG
	
	acceleration.y -= GRAVITY * airTime
	velocity += acceleration
	var lastVelocity = velocity
	velocity = move_and_slide(velocity, Vector3(0, 1, 0));
	
	if $HUD.stamina == stamina or stamina < 0:
		staminaCooldown += delta
		if staminaCooldown >= STAMINA_REGEN_TIME:
			stamina += delta/10
	
	$HUD.stamina = max(0, stamina)
	print(stamina)
	if (airTime != 0 and is_on_floor()):
		
		if (-lastVelocity.y > FALL_DAMAGE_THRESHOLD):
			hp -= (-lastVelocity.y-FALL_DAMAGE_THRESHOLD)/2
			hp = clamp(hp, 0, MAX_HEALTH)
			$HUD.hp = hp
			if hp == 0:
				$HUD/ColorRect.visible = true
				$HUD/Label.visible = true

func _input(event):
	if event is InputEventMouseButton:
		if (event.button_index == BUTTON_LEFT) and event.pressed:
			$Sword.swing()
	elif event is InputEventMouseMotion:
		rotate_y(TAU * -event.relative.x/800)
		if (abs(rotation.x + TAU * -event.relative.y/1000) < PI/2):
			$Head.rotate_object_local(Vector3(1, 0, 0), TAU * -event.relative.y/1000)
			$Head.rotation.x = -clamp(-$Head.rotation.x, -0.25*TAU, 0.25*TAU)

