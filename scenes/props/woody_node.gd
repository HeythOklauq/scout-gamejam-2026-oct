extends StaticBody3D
class_name WoodyNode

const WOOD_CHIP_NODE = preload("uid://dl1g3n0samtg3")
@onready var chip_spawn_point: Marker3D = $ChipSpawnPoint

@export var player_node :PlayerNode

var current_hp := 0.0
@export var max_hp := 1000*1000*1000
@export var hp_threshold := 5

@export var drop_vector_randomness := 0.2;
@export var drop_vector_strength := 10.0;
@export var max_drop_vector_strength := 15.0;
@export var max_woodchip_count := 100;
var free_woodchips :Array[WoodChipNode] = []
var used_woodchips :Array[WoodChipNode] = []

func _ready() -> void:
	current_hp = max_hp
	call_deferred("instantiate")

func instantiate() -> void:
	for i in max_woodchip_count:
		var new_woodchip = WOOD_CHIP_NODE.instantiate() as WoodChipNode;
		free_woodchips.push_back(new_woodchip);
		new_woodchip.picked_up.connect(on_woodchip_picked_up)

func _on_hittable_body_component_hit(direction: Vector3, strength: float) -> void:
	var old_hp_segments = ceil(current_hp / float(hp_threshold));
	current_hp -= strength * (player_node.combo_count + 1)
	var new_hp_segments = ceil(current_hp / float(hp_threshold));
	
	var delta_segments = (old_hp_segments - new_hp_segments)
	for i in delta_segments:
		spawn_woodchip(direction, strength)

func on_woodchip_picked_up(woodchip :WoodChipNode) -> void:
	used_woodchips.remove_at(used_woodchips.find(woodchip))
	free_woodchips.push_back(woodchip)

func spawn_woodchip(direction: Vector3, strength: float) -> void:
	var woodchip :WoodChipNode;
	if free_woodchips.size() > 0:
		woodchip = free_woodchips.pop_front()
	else:
		woodchip = used_woodchips.pop_front()
		woodchip.disappear()
	
	used_woodchips.push_back(woodchip)
	get_tree().root.add_child(woodchip);
	woodchip.global_position = chip_spawn_point.global_position;
	var random_direction_factor = Vector3(
		randf_range(-drop_vector_randomness, drop_vector_randomness), 
		randf_range(-drop_vector_randomness, drop_vector_randomness), 
		randf_range(-drop_vector_randomness, drop_vector_randomness)
	)
	var randomness_strength = 1.0 + randf_range(-drop_vector_randomness, drop_vector_randomness)
	var vector_strength = min(max_drop_vector_strength, randomness_strength * strength * drop_vector_strength)
	woodchip.apply_impulse((random_direction_factor + direction) * vector_strength, Vector3.ZERO);
