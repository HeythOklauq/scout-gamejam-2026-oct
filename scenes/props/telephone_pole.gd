extends StaticBody3D
class_name TelephonePoleNode

enum LINE_ANCHORS {
	A,
	B
}

@export var line_markers :Dictionary[LINE_ANCHORS, Node3D] = {}

func get_line_anchor(anchor_type :LINE_ANCHORS) -> Node3D:
	if line_markers.has(anchor_type):
		return line_markers[anchor_type]
	return 
