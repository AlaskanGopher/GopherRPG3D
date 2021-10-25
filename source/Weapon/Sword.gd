extends Spatial

export var BLADE_LENGTH : float = 1
export var DAMAGE : int = 5

func _ready():
	$Blade/CollisionShape.scale.z = BLADE_LENGTH
	$Blade/MeshInstance.scale.z = BLADE_LENGTH
	$Blade.translation.z = -BLADE_LENGTH

func getDamageDealt(entity : Spatial) -> int:
	if ($Blade.overlaps_body(entity)):
		var distance : float = $Hilt.global_transform.origin.distance_to(entity.global_transform.origin)
		return int(1 + DAMAGE * min(BLADE_LENGTH, distance) / BLADE_LENGTH)
	return 0

func swing(_continuous := false):
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.onHealthChange(-getDamageDealt(enemy))
