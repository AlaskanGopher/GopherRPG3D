extends KinematicBody

export var GRAVITY : float = 1
export var MAX_HEALTH : int = 100
var velocity : Vector3 = Vector3()
var airTime = 0;
var hp: int = MAX_HEALTH
var dead := false

func _ready():
	self.add_to_group("Enemies")

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
	if difference != 0 and not dead:
		hp += difference
		$"Viewport/HP Bar/InnerBar".rect_scale.x = float(hp)/float(MAX_HEALTH)
		$"Viewport/HP Bar/Label".text = str(hp)+"/"+str(MAX_HEALTH)
		if hp <= 0:
			dead = true
			$MeshInstance.visible = false
			$HUDObject.visible = false
			$Particles.emitting = true
