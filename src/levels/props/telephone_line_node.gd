extends Node3D
class_name TelephoneLineNode

@onready var mesh: CSGPolygon3D = $CSGPolygon3D
@onready var path_3d: Path3D = $Path3D

@export var pole_anchors :TelephonePoleNode.LINE_ANCHORS

@export var telephone_pole_container :Node3D

@export_category("Curve parameters")
@export_range(0.1, 5.0, 0.1) var curve_weight := 1.0
@export_range(0.0, 0.5, 0.02) var curve_progression_ratio := 0.1

@export_range(0.02, 1.0) var line_radius := 0.1:
	set(_value):
		line_radius = _value
		update_circle.call_deferred()
@export_range(3, 10) var perimeter_segments := 6:
	set(_value):
		perimeter_segments = _value
		update_circle.call_deferred()

var circle_coords :PackedVector2Array = []

var pole_animated := false

func _ready() -> void:
	initialise_line.call_deferred()

func update_circle() -> void:
	circle_coords = []
	var angle_increment = (PI * 2) / float(perimeter_segments);
	for degree in perimeter_segments:
		circle_coords.append(Vector2(
			line_radius * sin(degree * angle_increment),
			line_radius * cos(degree * angle_increment)
		))
	
	mesh.polygon = circle_coords

## Return the "out" and "in" of the bezier curve for the 2 positions
func _get_control_points(position_A :Vector3, position_B :Vector3) -> Array[Vector3]:
	var delta = (position_B-position_A)
	
	var out_control_point = Vector3(delta)
	out_control_point.x *= curve_progression_ratio
	out_control_point.z *= curve_progression_ratio
	out_control_point.y = -abs(out_control_point.y) - curve_weight
	
	var in_control_point = Vector3(delta)
	in_control_point.x *= -curve_progression_ratio
	in_control_point.z *= -curve_progression_ratio
	in_control_point.y = -abs(in_control_point.y) - curve_weight
	
	return [
		out_control_point,
		in_control_point
	]

func initialise_line() -> void:
	for pole in telephone_pole_container.get_children():
		pole = (pole as TelephonePoleNode)
		pole.on_hit.connect(_on_pole_hit)
		pole.on_animation_finished.connect(_on_pole_animation_finished)
	
	update_line()

func update_line() -> void:
	var new_curve := Curve3D.new()
	
	var control_point_to_previous := Vector3.ZERO
	var line_anchor_positions = telephone_pole_container.get_children().map(func(_pole :TelephonePoleNode): return _pole.get_line_anchor(pole_anchors).global_position)
	for anchor_index in line_anchor_positions.size():
		var anchor_position = line_anchor_positions[anchor_index]
		var different_position = true
		var control_point = [Vector3.ZERO]
		if (anchor_index + 1) < line_anchor_positions.size():
			var next_position = line_anchor_positions[anchor_index + 1]
			different_position = ((anchor_position - next_position) as Vector3).length_squared() > 0.01
			control_point = _get_control_points(anchor_position, next_position)
		
		if different_position:
			new_curve.add_point(anchor_position, control_point_to_previous, control_point[0])
		
		if (anchor_index + 1) < line_anchor_positions.size():
			control_point_to_previous = control_point[1]
	
	path_3d.curve = new_curve

func _process(_delta: float) -> void:
	if not pole_animated:
		return
	
	update_line()

func _on_pole_hit() -> void:
	pole_animated = true

func _on_pole_animation_finished() -> void:
	pole_animated = false
	update_line.call_deferred()
