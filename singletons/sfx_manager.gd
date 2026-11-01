extends Node

enum SOUND_TYPES {
	WIND_UP,
	SWING,
	BUNT,
	PICK_UP,
	IMPACT_WOOD,
	IMPACT_CONCRETE,
	IMPACT_METAL,
	NONE,
}

const SOUNDS :Dictionary[SOUND_TYPES, Array] = {
	SOUND_TYPES.NONE: [],
	SOUND_TYPES.WIND_UP: [
		preload("res://assets/audio/sfx/wind up2.wav")
	],
	SOUND_TYPES.SWING: [
		preload("res://assets/audio/sfx/swing.wav")
	],
	SOUND_TYPES.BUNT: [
		preload("res://assets/audio/sfx/swing.wav")
	],
	SOUND_TYPES.PICK_UP: [
		preload("uid://stiujfj5814e"), 
		preload("uid://c674f0pnbcqid"), 
		preload("uid://csque4rcnsc3c"), 
		preload("uid://c4oqrkoyrrg40"), 
		preload("uid://b174eqe5scpy8"), 
		preload("uid://bouccsto523wy"), 
		preload("uid://gfvhnkkdb4et"), 
		preload("uid://ccdg5wb0iwr03"), 
		preload("uid://drseai0hod72x"), 
		preload("uid://y1eccf4m4s66"), 
		preload("uid://do4g56rv5iwno")
	],
	SOUND_TYPES.IMPACT_WOOD: [
		preload("uid://bfa28h1p2ky5n"), 
		preload("uid://bkqp1birh5vsh"), 
		preload("uid://dhystfok6plyr"), 
		preload("uid://oxk3cut45kok"), 
		preload("uid://b33utbnontobh"), 
		preload("uid://1w2ea5wjx7v4")
	],
	SOUND_TYPES.IMPACT_CONCRETE: [
		preload("res://assets/audio/sfx/impactWood_light_001.ogg")
	],
	SOUND_TYPES.IMPACT_METAL: [
		preload("res://assets/audio/sfx/impactWood_light_001.ogg")
	]
}

var available_3d_audioplayers :Array[AudioStreamPlayer3D] = []
var in_usage_3d_audioplayers :Array[AudioStreamPlayer3D] = []

var available_audioplayers :Array[AudioStreamPlayer] = []
var in_usage_audioplayers :Array[AudioStreamPlayer] = []

func _ready() -> void:
	call_deferred("initialise_audioplayers")

func initialise_audioplayers() -> void:
	for audioplayer in get_children():
		audioplayer.finished.connect(_on_audioplayer_done.bind(audioplayer))
		
		if audioplayer is AudioStreamPlayer3D:
			available_3d_audioplayers.push_back(audioplayer)
		else:
			available_audioplayers.push_back(audioplayer)

func _init_audioplayer(audioplayer, audio_type :SOUND_TYPES, volume :float, pitch_modifier :float) :
	audioplayer.stop();
	audioplayer.stream = (SOUNDS[audio_type].pick_random() as AudioStream)
	audioplayer.volume_linear = volume
	audioplayer.pitch_scale = 1 + randf_range(-pitch_modifier, pitch_modifier);
	audioplayer.play()

# Play a sounds not positioned in world
func play_sound(audio_type :SOUND_TYPES, volume :float = 1.0, pitch_modifier :float = 0.1) -> AudioStreamPlayer:
	if audio_type == SOUND_TYPES.NONE:
		return
	var audioplayer :AudioStreamPlayer
	
	if available_audioplayers.size() > 0:
		audioplayer = available_audioplayers.pop_front()
	else:
		audioplayer = in_usage_audioplayers.pop_front()
	
	_init_audioplayer(audioplayer, audio_type, volume, pitch_modifier);
	in_usage_audioplayers.push_back(audioplayer)
	
	return audioplayer;

func play_3d_sound(target_global_position :Vector3, audio_type :SOUND_TYPES, volume :float = 1.0, pitch_modifier :float = 0.1) -> AudioStreamPlayer3D:
	if audio_type == SOUND_TYPES.NONE:
		return
	var audioplayer :AudioStreamPlayer3D
	
	if available_3d_audioplayers.size() > 0:
		audioplayer = available_3d_audioplayers.pop_front()
	else:
		audioplayer = in_usage_3d_audioplayers.pop_front()
	
	audioplayer.global_position = target_global_position
	_init_audioplayer(audioplayer, audio_type, volume, pitch_modifier);
	in_usage_3d_audioplayers.push_back(audioplayer)
	
	return audioplayer;

func stop_sound(audioplayer) -> void:
	audioplayer.stop();
	if audioplayer is AudioStreamPlayer3D:
		in_usage_3d_audioplayers.remove_at(in_usage_3d_audioplayers.find(audioplayer))
		available_3d_audioplayers.push_back(audioplayer)
	else:
		in_usage_audioplayers.remove_at(in_usage_audioplayers.find(audioplayer))
		available_audioplayers.push_back(audioplayer)

func _on_audioplayer_done(audioplayer) -> void:
	stop_sound(audioplayer)
