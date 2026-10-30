extends PlayerStateNode

var previous_state :PlayerStateNode

@export var swing_knockback := 100.0;
@export var bunt_knockback := 20.0;

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func on_entering_state(_previous_state :StateNode) -> void:
	previous_state = _previous_state
	
	player_node.combo_count += 1;
	
	var animation_name = "Swing_KnockedBack"
	var knockback_strength = swing_knockback;
	var knockback_duration = SlowMotionManager.MAJOR_SLOW;
	if player_node.is_on_floor():
		knockback_duration = SlowMotionManager.STANDARD_SLOW
	
	if _previous_state == state_machine.state_list["BuntState"]:
		animation_name = "Bunt_KnockedBack"
		knockback_strength = bunt_knockback
		knockback_duration = SlowMotionManager.MINOR_SLOW
	
	SlowMotionManager.slow_time(knockback_duration, 0.5);
	
	var hit_normal = -player_node.get_player_forward_angle()
	player_node.velocity.y = 0
	player_node.apply_movement(hit_normal, knockback_strength);
	
	animation_player.stop()
	animation_player.play(animation_name);

func process_frame(delta: float) -> StateNode:
	if animation_player.is_playing():
		return null
	
	return state_machine.state_list["IdleState"]
