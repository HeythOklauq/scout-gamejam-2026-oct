extends StaticBody3D
class_name WoodyNode

const WOOD_CHIP_NODE = preload("uid://dl1g3n0samtg3")
@onready var chip_spawn_point: Marker3D = $ChipSpawnPoint

func _on_hittable_body_component_hit(direction: Vector3, strength: float) -> void:
	var new_chip = WOOD_CHIP_NODE.instantiate() as WoodChipNode;
	
	get_tree().root.add_child(new_chip);
	new_chip.value = get_chip_value(strength)
	new_chip.global_position = chip_spawn_point.global_position
	new_chip.apply_impulse(direction * strength * 30.0, Vector3.ZERO);

func get_chip_value(strength: float) -> int:
	return strength
