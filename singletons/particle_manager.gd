extends Node

enum PARTICLE_TYPES {
	WOOD_IMPACT
}

const PARTICLE_SYSTEMS :Dictionary[PARTICLE_TYPES, Array] = {
	PARTICLE_TYPES.WOOD_IMPACT: [
	 	preload("uid://bwjeeuqr6cche")
	]
}

func spawn_particle(particle_type :PARTICLE_TYPES, global_position :Vector3, global_rotation :Vector3 = Vector3.ZERO) -> Node3D:
	var particle_instance = PARTICLE_SYSTEMS[particle_type].pick_random().instantiate()
	add_child(particle_instance)
	particle_instance.global_position = global_position
	particle_instance.global_rotation = global_rotation
	
	return particle_instance
