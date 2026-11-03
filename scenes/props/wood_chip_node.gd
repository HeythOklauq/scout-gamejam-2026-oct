extends RigidBody3D
class_name WoodChipNode

signal picked_up(woodchipNode :WoodChipNode)

@export var value := 1

func pick_up() -> void:
	GameplayManager.modify_currency(GameplayManager.CURRENCIES.WOODCHIP, value)
	SfxManager.play_3d_sound(global_position, SfxManager.SOUND_TYPES.PICK_UP);
	
	picked_up.emit(self);
