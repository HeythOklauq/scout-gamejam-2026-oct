extends RigidBody3D
class_name ProjectileNode

var hit_strength := 0.0
var bunt_strength := 20.0

@export var default_gravity_scale := 0.0
@export var bunt_gravity_scale := 0.8
@export var bunt_up_strength := 30.0

var last_player_attack_resource :AttackResource:
	set(_resource):
		last_player_attack_resource = _resource
		gravity_scale = default_gravity_scale if (last_player_attack_resource == null) or not (last_player_attack_resource is BumpAttackResource) else bunt_gravity_scale

func _on_hittable_body_component_hit(direction: Vector3, strength: float) -> void:
	hit_strength = strength
	
	var impulse_vector = direction * strength
	prints("ProjectileNode - _on_hittable_body_component_hit", impulse_vector)
	var impulse_strength_modifier := 1.0
	if last_player_attack_resource is BumpAttackResource:
		linear_velocity.y = 0
		impulse_strength_modifier = bunt_up_strength
	apply_impulse(direction * strength * impulse_strength_modifier)

func _on_area_3d_body_entered(body: Node3D) -> void:
	prints("ProjectileNode - _on_area_3d_body_entered", body)
	if body is WoodyNode:
		body._on_hittable_body_component_hit(linear_velocity, hit_strength)
		GameplayManager.combo_counter += 1
		queue_free()
	if body is PlayerNode:
		queue_free()
	
	queue_free()
