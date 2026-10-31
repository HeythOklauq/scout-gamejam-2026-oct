extends AttackResource
class_name BumpAttackResource

func get_reflect_angle(_attack_angle :Vector3) -> Vector3:
	return _attack_angle * -0.1 + Vector3.UP;
