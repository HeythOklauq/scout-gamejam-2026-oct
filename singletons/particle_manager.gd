extends Node

@onready var vector_tracer_node: Node3D = $VectorTracerNode

enum PARTICLE_TYPES {
	WOOD_IMPACT
}

const PARTICLE_SYSTEMS :Dictionary[PARTICLE_TYPES, Array] = {
	PARTICLE_TYPES.WOOD_IMPACT: [
	 	preload("uid://bwjeeuqr6cche")
	]
}

func _ready() -> void:
	if vector_tracer_node != null:
		vector_tracer_node.visible = OS.is_debug_build()

func spawn_particle(particle_type :PARTICLE_TYPES, global_position :Vector3, global_rotation :Vector3 = Vector3.ZERO) -> Node3D:
	var particle_instance = PARTICLE_SYSTEMS[particle_type].pick_random().instantiate()
	add_child(particle_instance)
	particle_instance.global_position = global_position
	particle_instance.global_rotation = global_rotation
	
	return particle_instance

func _spawn_vector(position :Vector3, orientation :Vector3, _length :float) -> void:
	vector_tracer_node.global_position = position
	vector_tracer_node.look_at(position + orientation)
