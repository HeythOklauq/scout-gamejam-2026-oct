extends PlayerStateNode

const WIND_UP_AUDIOSTREAM = preload("res://assets/audio/sfx/wind up2.wav")

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func is_valid_state() -> bool:
	return player_node.use_stamina();

func on_entering_state(_previous_state :StateNode, _state_data = null) -> void:
	SfxManager.play_sound(SfxManager.SOUND_TYPES.WIND_UP, 0.1, 0.02);
	animation_player.stop();
	animation_player.play("WindUp")

func process_frame(_delta: float) -> StateNode:
	if Input.is_action_just_pressed("Bunt"):
		return state_machine.state_list["BuntState"]
	
	if not animation_player.is_playing():
		return state_machine.state_list["ChargingState"]
	
	return null
