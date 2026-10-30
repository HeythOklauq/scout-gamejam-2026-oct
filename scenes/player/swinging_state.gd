extends PlayerStateNode

const SWING_AUDIOSTREAM = preload("res://assets/audio/sfx/swing.wav")

@onready var hurt_zone_area: Area3D = $"../../Camera3D/Swing_HurtZoneArea"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
var sfx :AudioStreamPlayer

var target_hit = null
@export var hurtzone_active := false:
	set(_state):
		hurtzone_active = _state;
		if hurtzone_active:
			call_deferred("on_activate_hurtbox")

func on_entering_state(_previous_state :StateNode) -> void:
	target_hit = null;
	
	sfx = SfxManager.play_sound(SfxManager.SOUND_TYPES.SWING, 0.1, 0.02);
	animation_player.stop();
	animation_player.play("Swing");

func on_exiting_state() -> void:
	hurtzone_active = false;
	target_hit = null

func on_activate_hurtbox() -> void:
	var hit_bodies := hurt_zone_area.get_overlapping_bodies();
	if hit_bodies.size() == 0:
		return
	
	on_hit(hit_bodies[0])

func _on_hurt_zone_area_body_entered(body: Node3D) -> void:
	if not hurtzone_active:
		return
	on_hit(body)

func on_hit(body :Node3D) -> void:
	if not hurtzone_active:
		return
	
	target_hit = body

func process_frame(delta: float) -> StateNode:
	if not animation_player.is_playing():
		return state_machine.state_list["IdleState"]
	
	if target_hit == null:
		return null
	
	if target_hit is HittableBody:
		target_hit.on_hit(hurt_zone_area.global_position, player_node.get_player_forward_angle())
	SfxManager.stop_sound(sfx)
	return state_machine.state_list["KnockbackedState"]
