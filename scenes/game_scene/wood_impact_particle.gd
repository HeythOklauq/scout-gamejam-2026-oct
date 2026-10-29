extends Node3D
class_name WoodImpactParticle

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

var random_pitch_scale = 0.1
@export var possible_sounds :Array[AudioStream] = []

func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	audio_stream_player_3d.pitch_scale = randf_range(1-random_pitch_scale, 1+random_pitch_scale);
	audio_stream_player_3d.stream = possible_sounds.pick_random();
	
	audio_stream_player_3d.play()
	cpu_particles_3d.emitting = true

func _on_cpu_particles_3d_finished() -> void:
	queue_free()
