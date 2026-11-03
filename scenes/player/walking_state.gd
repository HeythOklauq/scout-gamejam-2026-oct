extends PlayerStateNode

func process_frame(_delta: float) -> StateNode:
	if Input.is_action_just_pressed("Jump"):
		return state_machine.state_list["JumpingState"]
	if Input.is_action_just_pressed("Dash"):
		return state_machine.state_list["DashingState"]
	
	return null

func process_physics(_delta: float) -> StateNode:
	if GameplayManager.player_node.get_horizontal_velocity().length_squared() < GameplayManager.squared_max_walking_speed:
		var movement_vector = Vector3(
			Input.get_axis("Backward", "Forward"),
			0.0,
			Input.get_axis("StrafeRight","StrafeLeft")
		);
		
		GameplayManager.player_node.apply_relative_movement(movement_vector, GameplayManager.walking_speed * _delta)
	
	if GameplayManager.player_node.get_horizontal_velocity().length_squared() < 0.1:
		GameplayManager.player_node.velocity = Vector3.ZERO;
		return state_machine.state_list["IdleState"]
	
	if not GameplayManager.player_node.is_on_floor():
		return state_machine.state_list["FallingState"]
	
	return null;
