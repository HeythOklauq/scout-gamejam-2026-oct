extends PlayerStateNode
class_name AttackingState

const SWING_AUDIOSTREAM = preload("res://assets/audio/sfx/swing.wav")

enum ATTACK_RANGES {
	SHORT,
	MEDIUM
}

@export var hurtboxes_list :Dictionary[ATTACK_RANGES, Area3D] = {}

enum ATTACK_TYPES {
	SWING,
	BUNT,
	DOWNSWING
}

@export var attack_resources_list :Dictionary[ATTACK_TYPES, AttackResource] = {}
var current_attack_resource :AttackResource
var current_hurtbox: Area3D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var sfx
var target_hit = null
var strength_modifier := 1.0
@export var hurtzone_active := false:
	set(_state):
		hurtzone_active = _state;
		if hurtzone_active:
			on_activate_hurtbox()

func is_valid_state(previous_state :StateNode) -> bool:
	var is_bunt = (previous_state.attack_type == ATTACK_TYPES.BUNT)
	return (not is_bunt) or player_node.can_use_stamina();

func on_entering_state(_previous_state :StateNode) -> void:
	target_hit = null;
	
	if _previous_state.attack_type == ATTACK_TYPES.BUNT:
		player_node.use_stamina()
	strength_modifier = _previous_state.strength_modifier
	
	current_attack_resource = attack_resources_list[_previous_state.attack_type]
	
	sfx = SfxManager.play_sound(current_attack_resource.sfx_type, current_attack_resource.sfx_volume, current_attack_resource.sfx_variation);
	animation_player.stop();
	if animation_player.has_animation(current_attack_resource.animation_name):
		animation_player.play(current_attack_resource.animation_name);

func on_exiting_state() -> void:
	hurtzone_active = false;
	target_hit = null

func get_current_hurtbox() -> Area3D:
	return hurtboxes_list[current_attack_resource.range]

func on_activate_hurtbox() -> void:
	prints("on_activate_hurtbox")
	if not hurtzone_active:
		return
	
	var hurtbox = get_current_hurtbox()
	var hit_bodies := hurtbox.get_overlapping_bodies();
	
	if hit_bodies.size() == 0:
		return
	
	on_hit(hit_bodies[0])

func on_hit(body :Node3D) -> void:
	var hittable_component = HittableBodyComponent.get_hittable_component(body);
	if not hittable_component == null:
		hittable_component.on_hit(get_current_hurtbox().global_position, player_node.get_player_forward_angle(), strength_modifier)
	target_hit = body

func process_frame(delta: float) -> StateNode:
	if not animation_player.is_playing():
		return state_machine.state_list["IdleState"]
	
	if target_hit == null:
		return null
	
	if target_hit is HittableBodyComponent:
		target_hit.on_hit(hurtboxes_list[current_attack_resource.range].global_position, player_node.get_player_forward_angle())
	SfxManager.stop_sound(sfx)
	return state_machine.state_list["KnockbackedState"]

func _on_short_hurt_zone_area_body_entered(body: Node3D) -> void:
	prints("_on_short_hurt_zone_area_body_entered")
	if not hurtzone_active:
		return;
	if current_attack_resource.range == ATTACK_RANGES.SHORT:
		on_hit(body)

func _on_medium_hurt_zone_area_body_entered(body: Node3D) -> void:
	prints("_on_medium_hurt_zone_area_body_entered")
	if not hurtzone_active:
		return;
	if current_attack_resource.range == ATTACK_RANGES.MEDIUM:
		on_hit(body)
