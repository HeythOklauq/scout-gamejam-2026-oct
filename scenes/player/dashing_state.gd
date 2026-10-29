extends PlayerStateNode

var dash_duration = 0.2
var timer := 0.0

func on_entering_state() -> void:
	timer = dash_duration;
	var dash_direction :Vector3 = player_node.velocity
	if player_node.get_horizontal_velocity().length_squared() < 1.0:
		var h_velocity = player_node.get_player_forward_angle()
		dash_direction = Vector3(h_velocity.x, 0.0, h_velocity.y)
	
	SlowMotionManager.slow_time(SlowMotionManager.STANDARD_SLOW, 0.5);
	player_node.apply_movement(dash_direction, player_node.dash_speed);

func process_frame(delta: float) -> StateNode:
	timer -= delta
	
	if timer <= 0.0:
		return state_machine.state_list["IdleState"]
	return null

func process_physics(delta: float) -> StateNode:
	return null
