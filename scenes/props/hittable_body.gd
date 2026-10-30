extends PhysicsBody3D
class_name HittableBody

@export var on_hit_soundtype :SfxManager.SOUND_TYPES;
var swinging_tween :Tween

@export_group("Knockback values")
@export var knockback_angle := 10.0
@export var knockback_movement := 10.0
@export var animation_duration := 1.0

var default_position :Vector3
var default_rotation :Vector3

func _ready() -> void:
	default_position = position;
	default_rotation = rotation;

func on_hit(_impact_position :Vector3, _impact_direction :Vector3) -> void:
	SfxManager.play_3d_sound(_impact_position, on_hit_soundtype, 1.0, 0.1);
	
	if animation_duration == 0.0:
		return
	
	if not swinging_tween == null:
		swinging_tween.stop()
	
	swinging_tween = create_tween()
	swinging_tween.set_parallel(true)
	swinging_tween.set_trans(Tween.TRANS_ELASTIC)
	swinging_tween.set_ease(Tween.EASE_OUT)
	
	var perpendicular_axis = Vector3(_impact_direction.x, 0.0, _impact_direction.z).normalized().rotated(Vector3.UP, deg_to_rad(90.0));
	rotate(perpendicular_axis, deg_to_rad(knockback_angle))
	position = default_position + _impact_direction.normalized() * knockback_movement
	
	swinging_tween.tween_property(self, "rotation", default_rotation, animation_duration)
	swinging_tween.tween_property(self, "position", default_position, animation_duration)
