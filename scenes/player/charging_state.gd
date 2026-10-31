extends PlayerStateNode

var attack_type :AttackingState.ATTACK_TYPES

var time_passed := 0.0
@export var max_time := 1.0

@export var max_strength := 5.0

var strength_modifier := 1.0

func on_entering_state(_previous_state :StateNode) -> void:
	attack_type = AttackingState.ATTACK_TYPES.SWING
	time_passed = 0.0
	player_node.stamina_locked = true

func on_exiting_state() -> void:
	player_node.stamina_locked = false

func process_frame(_delta: float) -> StateNode:
	var attack_released := false;
	
	if Input.is_action_just_pressed("Bunt"):
		attack_type = AttackingState.ATTACK_TYPES.BUNT
		attack_released = true
	
	if not Input.is_action_pressed("Attack") or time_passed >= max_time:
		attack_released = true
		if not player_node.is_on_floor():
			attack_type = AttackingState.ATTACK_TYPES.SLAM
		strength_modifier = get_strength_power()
	
	if attack_released:
		return state_machine.state_list["AttackingState"]
	
	time_passed = min(time_passed+_delta, max_time);
	return null

func get_strength_power() -> float:
	return 1 + (max_strength -1) * (time_passed / max_time);
