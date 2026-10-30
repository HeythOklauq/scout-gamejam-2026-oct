extends PlayerStateNode

const SWING_AUDIOSTREAM = preload("res://assets/audio/sfx/swing.wav")

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var combat_audio_player: AudioStreamPlayer3D = $"../CombatAudioPlayer"

var hurtzone_active := false
var target_hit = null

func on_entering_state(_previous_state :StateNode) -> void:
	hurtzone_active = true;
	target_hit = null

func on_exiting_state() -> void:
	hurtzone_active = false;
	target_hit = null

func on_hit(body :Node3D) -> void:
	if not hurtzone_active:
		return
	
	target_hit = body

func process_frame(delta: float) -> StateNode:
	if target_hit == null:
		return null
	
	return state_machine.state_list["KnockbackedState"]
