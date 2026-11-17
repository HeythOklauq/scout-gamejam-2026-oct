@tool
extends Resource
class_name CustomCurveResource

@export var min_value := 0.0:
	set(_value):
		min_value = _value
		call_deferred("update_baking")
@export var max_value := 0.0:
	set(_value):
		max_value = _value
		call_deferred("update_baking")
var delta_value := 0.0

@export_range(0.0, 100.0, 1.0) var min_level := 0.0:
	set(_level):
		min_level = _level
		call_deferred("update_baking")
@export_range(1.0, 100.0, 1.0) var max_level := 1.0:
	set(_level):
		max_level = _level
		call_deferred("update_baking")
var delta_level := 0.0

@export var curve :Curve = Curve.new()

func _get_configuration_warnings():
	var warnings := []
	if min_value >= max_value:
		warnings.push_back("Min value must be lower than max value")
	if min_level >= max_level:
		warnings.push_back("Min level must be lower than max level")
	if curve == null:
		warnings.push_back("Curve undefined")
	return warnings

func _init() -> void:
	if not curve == null and delta_level > 1.0:
		curve.bake_resolution = int(delta_level)

func update_baking() -> void:
	delta_value = max_value - min_value
	delta_level = max_level - min_level
	
	if not curve == null:
		curve.bake_resolution = int(delta_level)
		curve.bake()

func _get_interval_level(level :int) -> float:
	return float((level - min_level)/delta_level)

func get_value(level :int) -> float:
	var internal_level = _get_interval_level(level+1)
	var curve_value = curve.sample_baked(internal_level);
	prints("get_value -", "get_relative_level(level)", internal_level, "curve_value", curve_value, "min_value", min_value)
	return min_value + (curve_value * delta_value)
