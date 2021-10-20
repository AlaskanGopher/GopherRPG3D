extends RigidBody

export var speed = 60
var velocity := Vector3()


func _ready():
	pass

func _integrate_forces(state):
	var input = Vector3()
	if Input.is_action_pressed("movement_up"):
		input.z -= 1
	if Input.is_action_pressed("movement_down"):
		input.z += 1
	if Input.is_action_pressed("movement_left"):
		input.x -= 1
	if Input.is_action_pressed("movement_right"):
		input.x += 1
	if (input.length_squared() > 0 and Vector2(state.linear_velocity.x, state.linear_velocity.z).length_squared() < speed):
		input = input.normalized() * speed
	if Input.is_action_pressed("movement_jump") and abs(state.get_velocity_at_local_position(Vector3()).y) < 0.01:
		input.y += 1000
	state.add_central_force(input.rotated(Vector3(0,1,0), rotation.y))

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(TAU * -event.relative.x/800)
		if (abs(rotation.x + TAU * -event.relative.y/1000) < PI/2):
			$Head.rotate_object_local(Vector3(1, 0, 0), TAU * -event.relative.y/1000)
			$Head.rotation.x = -clamp(-$Head.rotation.x, -0.25*TAU, 0.25*TAU)
