extends RigidBody3D
class_name WoodChipNode

@export var value := 1

func picked_up() -> void:
	SfxManager.play_3d_sound(global_position, SfxManager.SOUND_TYPES.PICK_UP);
	queue_free()
