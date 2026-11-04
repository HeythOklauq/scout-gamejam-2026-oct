extends PlayerStateNode

@export var falling_max_speed = -300.0
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func on_entering_state(_previous_state :StateNode) -> void:
	GameplayManager.pickup_locked = true

func on_exiting_state() -> void:
	GameplayManager.player_node.velocity.y = 0.0;
	GameplayManager.pickup_locked = false;

func process_frame(_delta: float) -> StateNode:
	if Input.is_action_just_pressed("Dash"):
		return state_machine.state_list["DashingState"]
	
	GameplayManager.player_node.velocity.y -= GameplayManager.falling_speed * _delta * default_gravity
	return null

func process_physics(_delta: float) -> StateNode:
	if GameplayManager.player_node.get_horizontal_velocity().length_squared() < GameplayManager.squared_max_walking_speed:
		var movement_vector = Vector3(
			Input.get_axis("Backward", "Forward"),
			0.0,
			Input.get_axis("StrafeRight","StrafeLeft")
		);
		
		GameplayManager.player_node.apply_relative_movement(movement_vector, GameplayManager.walking_speed * _delta)
		
	if GameplayManager.player_node.is_on_floor():
		return state_machine.state_list["IdleState"]
	return null
