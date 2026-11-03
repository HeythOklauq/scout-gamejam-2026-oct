@tool
extends Resource
class_name IncrementalUnlockResource

@export var unlock_name := "UNLOCKABLE RESOURCE"
@export var unlock_description := "LOL - LMAO even"

@export_group("Progression")
@export var current_level := 0
@export var unlock_level := 0
@export var progression_curve :CustomCurveResource

@export_group("Cost")
@export var money_price_curve :CustomCurveResource
@export var woodchip_price_curve :CustomCurveResource

func _get_configuration_warnings():
	var warnings := []
	var progression_levels
	var money_levels
	var woodchips_levels
	
	if progression_curve == null:
		warnings.push_back(str("progression curve empty"))
	else:
		progression_levels = Vector2(progression_curve.min_level, progression_curve.max_level);
		for tmp_warning in progression_curve._get_configuration_warnings():
			warnings.push_back(str("progression curve: ", tmp_warning))
	
	if not money_price_curve == null:
		money_levels = Vector2(money_price_curve.min_level, money_price_curve.max_level);
		for tmp_warning in money_price_curve._get_configuration_warnings():
			warnings.push_back(str("money curve: ", tmp_warning))
	
	if not woodchip_price_curve == null:
		woodchips_levels = Vector2(woodchip_price_curve.min_level, woodchip_price_curve.max_level);
		for tmp_warning in woodchip_price_curve._get_configuration_warnings():
			warnings.push_back(str("woodchip curve: ", tmp_warning))
	
	if progression_levels != null:
		if (money_levels != null) and progression_levels != money_levels:
			warnings.push_back(str("Min/Max levels not matching between progression (", progression_levels,") and money cost (", money_levels,")"));
		if (woodchips_levels != null) and progression_levels != woodchips_levels:
			warnings.push_back(str("Min/Max levels not matching between progression (", progression_levels,") and woodchip cost (", woodchips_levels,")"));
	
	return warnings

func is_unlocked() -> bool:
	return unlock_level > 0;

func is_active() -> bool:
	return current_level > 0;

func get_current_value() -> float:
	return progression_curve.get_value(current_level);

func can_upgrade() -> bool:
	var can_offer := true;
	can_offer = can_offer and get_upgrade_money_price() <= GameplayManager.player_currencies[GameplayManager.CURRENCIES.MONEY]
	can_offer = can_offer and get_upgrade_woodchip_price() <= GameplayManager.player_currencies[GameplayManager.CURRENCIES.WOODCHIP]
	return can_offer

func upgrade() -> void:
	GameplayManager.player_currencies[GameplayManager.CURRENCIES.MONEY] -= get_upgrade_money_price()
	GameplayManager.player_currencies[GameplayManager.CURRENCIES.WOODCHIP] -= get_upgrade_woodchip_price()
	unlock_level += 1
	current_level = unlock_level

func is_max_level() -> bool:
	return unlock_level == progression_curve.max_level

func get_upgrade_money_price() -> int:
	if money_price_curve == null:
		return 0
	
	return int(money_price_curve.get_value(unlock_level + 1));

func get_upgrade_woodchip_price() -> int:
	if woodchip_price_curve == null:
		return 0
	return int(woodchip_price_curve.get_value(unlock_level + 1));
