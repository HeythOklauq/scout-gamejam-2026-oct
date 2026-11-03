extends Resource
class_name AttackResource

@export_subgroup("Animation")
@export var animation_name :String
@export var knockback_animation_name :String

@export_subgroup("Physics and score")
@export var attack_range :AttackingState.ATTACK_RANGES
@export var knockback_player :float = 0.5
@export var strength := 1.0
@export var charging_impact := 0.0
@export var velocity_impact := 0.0

@export_subgroup("SFX")
@export var sfx_type :SfxManager.SOUND_TYPES
@export var sfx_volume :float = 1.0
@export var sfx_variation :float = 0.01

func get_reflect_angle(_attack_angle :Vector3) -> Vector3:
	return GameplayManager.player_node.get_player_forward_angle();

func get_attack_strength( state_strength_modifier :float ) -> float:
	var unlockable_strength_mod = 1.0 + GameplayManager.UNLOCKABLES[GameplayManager.UNLOCKABLE_TYPES.SWING].get_current_value()
	var base_strength = strength * unlockable_strength_mod
	
	var unlockable_charging_modifier = 0.0
	if GameplayManager.UNLOCKABLES[GameplayManager.UNLOCKABLE_TYPES.WIND_UP].is_unlocked():
		unlockable_charging_modifier = 1.0 + GameplayManager.UNLOCKABLES[GameplayManager.UNLOCKABLE_TYPES.SWING].get_current_value()
	var charging_strength = (state_strength_modifier * charging_impact) * unlockable_charging_modifier
	
	var velocity_value = GameplayManager.player_node.velocity.length_squared() / 20.0
	var velocity_strength = velocity_value * velocity_impact
	
	var total = base_strength + charging_strength + velocity_strength
	prints("ATTACK DAMAGE: ", total, " (base_strength", base_strength, " + charging_strength", charging_strength, " + velocity_strength", velocity_strength, ")")
	prints(" - Base attack damage: ", strength, " (Base attack type strength) * ", unlockable_strength_mod, " (unlockable strength mod)")
	prints(" - Charge attack damage: ", charging_strength, " (Charging strength) * ", charging_impact, " (Impact of charging for that attack) * ", unlockable_charging_modifier, " (unlockable charging mod)")
	prints(" - Velocity attack damage: ", velocity_value, " (Velocity speed) * ", velocity_strength, " (Impact of velocity)")
	
	return base_strength + charging_strength + velocity_strength
