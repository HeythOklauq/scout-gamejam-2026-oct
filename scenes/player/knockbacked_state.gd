extends PlayerStateNode

var previous_state :PlayerStateNode

@export var knockback_base := 20.0;
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@export_range(0.1, 10.0) var max_strength_modifier_on_knockback := 1.0;

func on_entering_state(_previous_state :StateNode) -> void:
	previous_state = _previous_state
	
	player_node.combo_count += 1;
	
	var attack_resource :AttackResource = _previous_state.current_attack_resource
	
	var knockback_strength = attack_resource.strength * knockback_base * min(_previous_state.strength_modifier, max_strength_modifier_on_knockback);
	var knockback_duration = SlowMotionManager.MAJOR_SLOW;
	
	SlowMotionManager.slow_time(knockback_duration, 0.5);
	
	var hit_normal = -player_node.get_player_forward_angle()
	attack_resource.get_reflect_angle(player_node.get_player_forward_angle())
	player_node.velocity.y = 0
	player_node.apply_movement(hit_normal, knockback_strength);
	
	animation_player.stop()
	if animation_player.has_animation(attack_resource.knockback_animation_name):
		animation_player.play(attack_resource.knockback_animation_name)

func process_frame(delta: float) -> StateNode:
	if animation_player.is_playing():
		return null
	
	return state_machine.state_list["IdleState"]
