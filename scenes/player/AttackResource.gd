extends Resource
class_name AttackResource

@export_subgroup("Animation")
@export var animation_name :String
@export var knockback_animation_name :String

@export_subgroup("Physics and score")
@export var range :AttackingState.ATTACK_RANGES
@export var knockback_player :float = 0.5
@export var strength := 1.0
@export var charging_impact := 0.0

@export_subgroup("SFX")
@export var sfx_type :SfxManager.SOUND_TYPES
@export var sfx_volume :float = 1.0
@export var sfx_variation :float = 0.01

func get_reflect_angle(_attack_angle :Vector3) -> Vector3:
	return _attack_angle * -1;
