extends Node3D
class_name WoodchipWorldborder

func _on_area_3d_body_entered(body: Node3D) -> void:
	body = body as WoodChipNode
	if body == null:
		return
	
	body.pick_up()
