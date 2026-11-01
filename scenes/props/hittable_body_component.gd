extends Node
class_name HittableBodyComponent

signal hit(direction :Vector3, strength :float)

var targetted_item :Node3D

@export var on_hit_soundtype :SfxManager.SOUND_TYPES;
var animation_tween :Tween

@export_group("Knockback values")
@export var knockback_angle := 10.0
@export var knockback_movement := 10.0
@export var animation_duration := 1.0

var default_position :Vector3
var default_rotation :Vector3

func _ready() -> void:
	targetted_item = get_parent();
	if targetted_item == null:
		return
	default_position = targetted_item.position;
	default_rotation = targetted_item.rotation;

func on_hit(_impact_position :Vector3, _impact_direction :Vector3, hit_strength :float = 1.0) -> void:
	SfxManager.play_3d_sound(_impact_position, on_hit_soundtype, 1.0, 0.1);
	
	hit.emit(_impact_direction, hit_strength);
	prints("HIT", targetted_item.name)
	if animation_duration == 0.0:
		return
	
	if not animation_tween == null:
		animation_tween.stop()
	
	animation_tween = create_tween()
	animation_tween.set_parallel(true)
	animation_tween.set_trans(Tween.TRANS_ELASTIC)
	animation_tween.set_ease(Tween.EASE_OUT)
	
	var perpendicular_axis = Vector3(_impact_direction.x, 0.0, _impact_direction.z).normalized().rotated(Vector3.UP, deg_to_rad(90.0));
	targetted_item.rotate(perpendicular_axis, deg_to_rad(knockback_angle))
	targetted_item.position = default_position + _impact_direction.normalized() * knockback_movement
	
	animation_tween.tween_property(targetted_item, "rotation", default_rotation, animation_duration)
	animation_tween.tween_property(targetted_item, "position", default_position, animation_duration)

static func get_hittable_component(node :Node3D) -> HittableBodyComponent:
	var result :HittableBodyComponent
	
	for child in node.get_children():
		if child is HittableBodyComponent:
			return (child as HittableBodyComponent)
	
	return result
