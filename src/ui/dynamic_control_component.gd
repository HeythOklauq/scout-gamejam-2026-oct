extends Node
class_name DynamicControlComponent

@export var target_control :Control

@export var hovered_rotation := 0.0
var default_rotation := 0.0

@export var hovered_scale := 1.0
var _default_scale := 1.0

@export var transformation_duration := 0.1

@export var in_transition_type := Tween.TransitionType.TRANS_ELASTIC
@export var in_ease_type := Tween.EaseType.EASE_OUT_IN

@export var out_transition_type := Tween.TransitionType.TRANS_ELASTIC
@export var out_ease_type := Tween.EaseType.EASE_OUT_IN

var disabled := false

func _ready() -> void:
	initialize.call_deferred()

func initialize() -> void:
	if target_control == null:
		return
	
	default_rotation = target_control.rotation
	_default_scale = target_control.scale.x
	
	target_control.pivot_offset_ratio = (Vector2.ONE * 0.5)
	target_control.mouse_entered.connect(_on_control_mouse_entered)
	target_control.mouse_exited.connect(_on_control_mouse_exited)


var _tween :Tween
func _on_control_mouse_entered() -> void:
	if not is_inside_tree() or disabled:
		return
	
	if not _tween == null:
		_tween.stop()
	
	_tween = create_tween()
	_tween.set_ignore_time_scale(true)
	_tween.set_ease(in_ease_type)
	_tween.set_trans(in_transition_type)
	_tween.parallel().tween_property(target_control, "scale", Vector2.ONE * hovered_scale, transformation_duration)
	_tween.parallel().tween_property(target_control, "rotation", [1, -1].pick_random() * deg_to_rad(hovered_rotation), transformation_duration)

func _on_control_mouse_exited() -> void:
	if not is_inside_tree():
		return
	
	if not _tween == null:
		_tween.stop()
	
	_tween = create_tween()
	_tween.set_ignore_time_scale(true)
	_tween.set_trans(out_transition_type)
	_tween.set_ease(out_ease_type)
	_tween.parallel().tween_property(target_control, "scale", Vector2.ONE * _default_scale, transformation_duration)
	_tween.parallel().tween_property(target_control, "rotation", default_rotation, transformation_duration)
