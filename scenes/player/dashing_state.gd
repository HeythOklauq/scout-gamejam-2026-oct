extends PlayerStateNode

var dash_duration = 0.2
var timer := 0.0

func is_valid_state(_previous_state :StateNode) -> bool:
	return GameplayManager.can_use_stamina() and GameplayManager.UNLOCKABLES[GameplayManager.UNLOCKABLE_TYPES.STEAL].is_unlocked();

func on_entering_state(_previous_state :StateNode) -> void:
	GameplayManager.use_stamina();
	timer = dash_duration;
	var dash_direction :Vector3 = GameplayManager.player_node.velocity
	if GameplayManager.player_node.get_horizontal_velocity().length_squared() < 1.0:
		var h_velocity = GameplayManager.player_node.get_player_forward_angle()
		dash_direction = Vector3(h_velocity.x, 0.0, h_velocity.y)
	
	SlowMotionManager.slow_time(SlowMotionManager.MINOR_SLOW, 0.3);
	GameplayManager.player_node.apply_movement(dash_direction, GameplayManager.dash_speed);
	GameplayManager.attack_locked = false

func on_exiting_state() -> void:
	GameplayManager.attack_locked = false

func process_frame(_delta: float) -> StateNode:
	timer -= _delta
	
	if timer <= 0.0:
		return state_machine.state_list["IdleState"]
	return null

func process_physics(_delta: float) -> StateNode:
	return null
