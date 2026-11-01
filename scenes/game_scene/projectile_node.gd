extends RigidBody3D
class_name ProjectileNode

func _on_hittable_body_component_hit(direction: Vector3, strength: float) -> void:
	var impulse_vector = direction * strength
	prints("_on_hittable_body_component_hit", impulse_vector)
	apply_impulse(impulse_vector)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is WoodyNode:
		queue_free()
	if body is PlayerNode:
		queue_free()
