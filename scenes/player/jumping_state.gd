extends PlayerStateNode


func on_entering_state() -> void:
	player_node.velocity.y = player_node.jump_speed;

func on_exiting_state() -> void:
	player_node.velocity.y = 0.0;

func process_input(event: InputEvent) -> StateNode:
	if Input.is_action_just_pressed("Attack"):
		player_node.attack()
	
	if Input.is_action_just_pressed("Dash"):
		return dashing_state
	
	return null


func process_frame(delta: float) -> StateNode:
	player_node.velocity.y -= player_node.falling_speed * delta
	if player_node.velocity.y <= 0.0:
		return falling_state
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
		return idle_state
	return null
