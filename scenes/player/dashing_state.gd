extends PlayerStateNode

var dash_duration = 0.3
var timer := 0.0
var dash_direction :Vector3

@export var FOV_modifier := 5.0
var camera_default_fov :float
var fov_tween :Tween

func is_valid_state(_previous_state :StateNode) -> bool:
	return GameplayManager.can_use_stamina() and GameplayManager.UNLOCKABLES[GameplayManager.UNLOCKABLE_TYPES.STEAL].is_unlocked();

func on_entering_state(_previous_state :StateNode) -> void:
	camera_default_fov = GameplayManager.player_node.camera.fov
	GameplayManager.use_stamina();
	GameplayManager.dashing = true;
	
	timer = dash_duration;
	dash_direction = GameplayManager.player_node.get_player_forward_angle()
	#SlowMotionManager.slow_time(SlowMotionManager.MAJOR_SLOW, dash_duration/2.0);
	SfxManager.play_sound(SfxManager.SOUND_TYPES.WIND_UP, 0.05, 0.02);
	GameplayManager.player_node.velocity = dash_direction * GameplayManager.dash_speed
	GameplayManager.player_node.camera.fov += FOV_modifier
	
	if fov_tween != null:
		fov_tween.stop()
	
	fov_tween = create_tween()
	fov_tween.tween_property(GameplayManager.player_node.camera, "fov", camera_default_fov, dash_duration);

func on_exiting_state() -> void:
	GameplayManager.dashing = false;
	GameplayManager.player_node.camera.fov = camera_default_fov

func process_frame(_delta: float) -> StateNode:
	timer -= _delta
	
	if timer <= 0.0:
		return state_machine.state_list["IdleState"]
	return null

func process_physics(_delta: float) -> StateNode:
	GameplayManager.player_node.velocity = dash_direction * GameplayManager.dash_speed
	return null
