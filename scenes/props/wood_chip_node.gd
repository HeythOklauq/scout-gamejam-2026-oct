extends RigidBody3D
class_name WoodChipNode

signal picked_up(woodchipNode :WoodChipNode)

@export var value := 1

func disappear() -> void:
	SfxManager.play_3d_sound(global_position, SfxManager.SOUND_TYPES.PICK_UP);

func pick_up() -> void:
	disappear()
	get_parent().remove_child(self);
	picked_up.emit(self);
