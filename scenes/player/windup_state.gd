extends PlayerStateNode

const WIND_UP_AUDIOSTREAM = preload("res://assets/audio/sfx/wind up2.wav")

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var attack_type :AttackingState.ATTACK_TYPES
var strength_modifier := 1.0

func is_valid_state(previous_state :StateNode) -> bool:
	return player_node.can_use_stamina();

func on_entering_state(_previous_state :StateNode) -> void:
	player_node.use_stamina()
	SfxManager.play_sound(SfxManager.SOUND_TYPES.WIND_UP, 0.1, 0.02);
	attack_type = AttackingState.ATTACK_TYPES.SWING
	animation_player.play("WindUp")

func process_frame(_delta: float) -> StateNode:
	if Input.is_action_just_pressed("Bunt"):
		attack_type = AttackingState.ATTACK_TYPES.BUNT
		return state_machine.state_list["AttackingState"]
	
	if not animation_player.is_playing(): 
		return state_machine.state_list["ChargingState"]
	
	return null
