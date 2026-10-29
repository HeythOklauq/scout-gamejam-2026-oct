extends PlayerStateNode

func process_frame(delta: float) -> StateNode:
	if Input.is_action_just_pressed("Attack"):
		player_node.attack()
	
	if Input.is_action_just_pressed("Jump"):
		return state_machine.state_list["JumpingState"]
	if Input.is_action_just_pressed("Dash"):
		return state_machine.state_list["DashingState"]
	
	return null

func process_physics(delta: float) -> StateNode:
	if player_node.get_horizontal_velocity().length_squared() < player_node.squared_max_walking_speed:
		var movement_vector = Vector3(
			Input.get_axis("Backward", "Forward"),
			0.0,
			Input.get_axis("StrafeRight","StrafeLeft")
		);
		
		player_node.apply_relative_movement(movement_vector, player_node.walking_speed * delta)
	
	if player_node.get_horizontal_velocity().length_squared() < 0.1:
		player_node.velocity = Vector3.ZERO;
		return state_machine.state_list["IdleState"]
	
	if not player_node.is_on_floor():
		return state_machine.state_list["FallingState"]
	
	return null;
