extends Node3D

@export var target :Node3D
@export var camera_layer_index := 20

func _ready() -> void:
	call_deferred("initialize_position");

func initialize_position() -> void:
	if target == null:
		return 
	
	global_position = Vector3.ZERO
	recursive_layer_set(self);

func recursive_layer_set(node :Node3D) -> void:
	if node is VisualInstance3D:
		for i in 20:
			node.set_layer_mask_value(i+1, false)
		node.set_layer_mask_value(camera_layer_index, true)
	
	for child in node.get_children():
		recursive_layer_set(child)
