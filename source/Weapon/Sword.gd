extends Spatial

export var BLADE_LENGTH    : float = .75
export var DAMAGE          : int = 12
export var COOLDOWN_LENGTH : float = .5

var cooldown = 0

func _ready():
	pass

func getDamageDealt(entity : Spatial) -> int:
	if ($Blade.overlaps_body(entity)):
		var distance : float = $Hilt.global_transform.origin.distance_to(entity.global_transform.origin)
		return int(1 + DAMAGE * min(BLADE_LENGTH, distance) / BLADE_LENGTH)
	return 0

func _physics_process(delta):
	cooldown += delta

func swing(_continuous := false):
	if cooldown > COOLDOWN_LENGTH:
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			var damage = getDamageDealt(enemy)
			if damage != 0:
				enemy.onHealthChange(-damage)
				cooldown = 0
	else:
		print("calm down")
