extends PlayerStateNode

var dash_duration = 0.2
var timer := 0.0

func is_valid_state() -> bool:
	return player_node.use_stamina();

func on_entering_state(_previous_state :StateNode, _state_data = null) -> void:
	timer = dash_duration;
	var dash_direction :Vector3 = player_node.velocity
	if player_node.get_horizontal_velocity().length_squared() < 1.0:
		var h_velocity = player_node.get_player_forward_angle()
		dash_direction = Vector3(h_velocity.x, 0.0, h_velocity.y)
	
	SlowMotionManager.slow_time(SlowMotionManager.MINOR_SLOW, 0.3);
	player_node.apply_movement(dash_direction, player_node.dash_speed);
	player_node.attack_locked = false

func on_exiting_state() -> void:
	player_node.attack_locked = false

func process_frame(delta: float) -> StateNode:
	timer -= delta
	
	if timer <= 0.0:
		return state_machine.state_list["IdleState"]
	return null

func process_physics(delta: float) -> StateNode:
	return null
