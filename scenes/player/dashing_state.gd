extends PlayerStateNode

var dash_duration = 0.3
var timer := 0.0
var dash_direction :Vector3

func is_valid_state(_previous_state :StateNode) -> bool:
	return GameplayManager.can_use_stamina() and GameplayManager.UNLOCKABLES[GameplayManager.UNLOCKABLE_TYPES.STEAL].is_unlocked();

func on_entering_state(_previous_state :StateNode) -> void:
	GameplayManager.use_stamina();
	timer = dash_duration;
	dash_direction = GameplayManager.player_node.get_player_forward_angle()
	
	#SlowMotionManager.slow_time(SlowMotionManager.MAJOR_SLOW, dash_duration/2.0);
	GameplayManager.player_node.velocity = dash_direction * GameplayManager.dash_speed
	GameplayManager.attack_locked = false

func on_exiting_state() -> void:
	GameplayManager.attack_locked = false

func process_frame(_delta: float) -> StateNode:
	timer -= _delta
	
	if timer <= 0.0:
		return state_machine.state_list["IdleState"]
	return null

func process_physics(_delta: float) -> StateNode:
	GameplayManager.player_node.velocity = dash_direction * GameplayManager.dash_speed
	return null
