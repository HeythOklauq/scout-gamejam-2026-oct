extends PlayerStateNode

const WIND_UP_AUDIOSTREAM = preload("res://assets/audio/sfx/wind up2.wav")

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var combat_audio_player: AudioStreamPlayer3D = $"../CombatAudioPlayer"

func on_entering_state(_previous_state :StateNode) -> void:
	animation_player.play()
