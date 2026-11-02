extends Node3D
class_name ImpactParticle

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D
@export var particle_amout := 5
@export var particle_scaling := 1.0

func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	cpu_particles_3d.amount = particle_amout
	(cpu_particles_3d.mesh as QuadMesh).size *= particle_scaling
	cpu_particles_3d.emitting = true

func _on_cpu_particles_3d_finished() -> void:
	queue_free()
