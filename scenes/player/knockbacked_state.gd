extends PlayerStateNode

var previous_state :PlayerStateNode
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func on_entering_state(_previous_state :StateNode) -> void:
	previous_state = _previous_state
	
	var animation_name = "KnockedBack"
	var knockback_duration = SlowMotionManager.MAJOR_SLOW;
	if player_node.is_on_floor():
		knockback_duration = SlowMotionManager.STANDARD_SLOW
	
	if _previous_state == state_machine.state_list["PuntState"]:
		animation_name = "RESET"
		knockback_duration = SlowMotionManager.MINOR_SLOW_SLOW
	
	SlowMotionManager.slow_time(knockback_duration, 0.5);
	
	animation_player.stop()
	animation_player.play(animation_name);

func process_frame(delta: float) -> StateNode:
	if animation_player.is_playing():
		return null
	
	return state_machine.state_list["IdleState"]
