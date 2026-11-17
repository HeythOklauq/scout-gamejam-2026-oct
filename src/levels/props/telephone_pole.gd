extends StaticBody3D
class_name TelephonePoleNode

signal on_hit()
signal on_animation_finished()

enum LINE_ANCHORS {
	A,
	B
}

@export var line_markers :Dictionary[LINE_ANCHORS, Node3D] = {}

func get_line_anchor(anchor_type :LINE_ANCHORS) -> Node3D:
	if line_markers.has(anchor_type):
		return line_markers[anchor_type]
	return 

func _on_hittable_body_component_hit(_direction: Vector3, _strength: float) -> void:
	on_hit.emit()

func _on_hittable_body_component_animation_finished() -> void:
	on_animation_finished.emit()
