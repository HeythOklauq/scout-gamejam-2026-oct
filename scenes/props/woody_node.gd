extends StaticBody3D
class_name WoodyNode

@onready var woodchips_pooled_component: PoolPrefabComponent = %WoodchipsPooledComponent
@onready var projectiles_pooled_component: PoolPrefabComponent = %ProjectilesPooledComponent

@onready var chip_spawn_point: Marker3D = $ChipSpawnPoint
@onready var projectile_spawn_point: Marker3D = $ProjectileSpawnPoint

var current_hp := 0.0
@export var max_hp := 1000*1000*1000
@export var hp_threshold := 5

@export var damage_indicator_node :DamageNumberNode

@export var drop_vector_randomness := 0.2;
@export var drop_vector_strength := 0.4;
@export var max_drop_vector_strength := 1.0;

func _ready() -> void:
	current_hp = max_hp
	GameplayManager.woody_node = self
	call_deferred("instantiate")

func instantiate() -> void:
	for woodchip in woodchips_pooled_component.get_instances(woodchips_pooled_component.INSTANCE_STATUS.ALL):
		woodchip.picked_up.connect(on_woodchip_picked_up)

func _on_hittable_body_component_hit(direction: Vector3, strength: float) -> void:
	if not direction.is_normalized():
		direction = direction.normalized()
	
	var old_hp_segments = ceil(current_hp / float(hp_threshold));
	var damages = strength * (GameplayManager.combo_counter + 1)
	current_hp -= damages
	var new_hp_segments = ceil(current_hp / float(hp_threshold));
	
	var delta_segments = (old_hp_segments - new_hp_segments)
	if delta_segments > woodchips_pooled_component.pool_size:
		var overflow = delta_segments - woodchips_pooled_component.pool_size;
		GameplayManager.modify_currency(GameplayManager.CURRENCIES.WOODCHIP, overflow)
		delta_segments = woodchips_pooled_component.pool_size
	
	for i in delta_segments:
		spawn_woodchip(direction, strength)
	
	if damage_indicator_node != null:
		damage_indicator_node.show_damage(damages)
	
	ParticleManager.spawn_particle(ParticleManager.PARTICLE_TYPES.WOOD_IMPACT, chip_spawn_point.global_position);

func on_woodchip_picked_up(woodchip :WoodChipNode, by_player :bool) -> void:
	if not by_player:
		return
	get_tree().root.remove_child(woodchip);
	woodchips_pooled_component.uninstantiate(woodchip);

func reset_woodchips() -> void:
	for woodchip in woodchips_pooled_component.get_instances(PoolPrefabComponent.INSTANCE_STATUS.USED):
		woodchips_pooled_component.uninstantiate(woodchip);
		get_tree().root.remove_child(woodchip);

func spawn_woodchip(direction: Vector3, strength: float) -> void:
	var woodchip := woodchips_pooled_component.get_instance() as WoodChipNode;
	if not woodchip.is_inside_tree():
		get_tree().root.add_child(woodchip)
	
	woodchip.global_position = chip_spawn_point.global_position;
	var random_direction_factor = Vector3(
		randf_range(-drop_vector_randomness, drop_vector_randomness), 
		randf_range(-drop_vector_randomness, drop_vector_randomness), 
		randf_range(-drop_vector_randomness, drop_vector_randomness)
	)
	var randomness_strength = 1.0 + randf_range(-drop_vector_randomness, drop_vector_randomness)
	var vector_strength = min(max_drop_vector_strength, randomness_strength * strength * drop_vector_strength)
	woodchip.set_axis_velocity((random_direction_factor + direction) * vector_strength);


func _on_woodchips_pooled_component_reinstanciate_prefab(node: Node) -> void:
	node = node as WoodChipNode;
	node.pick_up(false)
