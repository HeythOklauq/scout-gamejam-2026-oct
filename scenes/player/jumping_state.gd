extends PlayerStateNode

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func on_entering_state(_previous_state :StateNode) -> void:
	player_node.velocity.y = player_node.jump_speed;

func on_exiting_state() -> void:
	player_node.velocity.y = 0.0;

func process_frame(delta: float) -> StateNode:
	if Input.is_action_just_pressed("Dash"):
		return state_machine.state_list["DashingState"]
	
	if Input.is_action_just_pressed("Attack"):
		player_node.attack()
	
	player_node.velocity.y -= player_node.falling_speed * delta * default_gravity
	if player_node.velocity.y <= 0.0:
		return state_machine.state_list["FallingState"]
	return null

func process_physics(delta: float) -> StateNode:
	if player_node.get_horizontal_velocity().length_squared() < player_node.squared_max_walking_speed:
		var movement_vector = Vector3(
			Input.get_axis("Backward", "Forward"),
			0.0,
			Input.get_axis("StrafeRight","StrafeLeft")
		);
		
		player_node.apply_relative_movement(movement_vector, player_node.walking_speed * delta)
	
	if player_node.is_on_floor():
		return state_machine.state_list["IdleState"]
	return null
