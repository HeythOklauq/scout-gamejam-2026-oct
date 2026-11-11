extends PlayerStateNode
class_name AttackingState

const SWING_AUDIOSTREAM = preload("res://assets/audio/sfx/swing.wav")

enum ATTACK_RANGES {
	SHORT,
	MEDIUM,
	VERTICAL
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
	return (not is_bunt) or GameplayManager.can_use_stamina();

func on_entering_state(_previous_state :StateNode) -> void:
	target_hit = null;
	
	if _previous_state.attack_type == ATTACK_TYPES.BUNT:
		GameplayManager.use_stamina()
	strength_modifier = _previous_state.strength_modifier
	
	current_attack_resource = attack_resources_list[_previous_state.attack_type]
	
	sfx = SfxManager.play_sound(current_attack_resource.sfx_type, current_attack_resource.sfx_volume, current_attack_resource.sfx_variation);
	if animation_player.has_animation(current_attack_resource.animation_name):
		animation_player.play(current_attack_resource.animation_name);

func on_exiting_state() -> void:
	hurtzone_active = false;
	target_hit = null

func get_current_hurtbox() -> Area3D:
	return hurtboxes_list[current_attack_resource.attack_range]

func on_activate_hurtbox() -> void:
	if not hurtzone_active:
		return
	
	var hurtbox = get_current_hurtbox()
	var hit_bodies := hurtbox.get_overlapping_bodies();
	
	if hit_bodies.size() == 0:
		return
	
	print("on_activate_hurtbox hit")
	on_hit(hit_bodies[0])

func on_hit(body :Node3D) -> void:
	hurtzone_active = false;
	var hittable_component = HittableBodyComponent.get_hittable_component(body);
	if not hittable_component == null:
		var hit_direction = GameplayManager.player_node.get_player_forward_angle()
		if hittable_component.targetted_item is ProjectileNode:
			hit_direction = current_attack_resource.get_reflect_angle(-hit_direction)
			hittable_component.targetted_item.last_player_attack_resource = current_attack_resource
		
		hittable_component.on_hit(get_current_hurtbox().global_position, hit_direction, current_attack_resource.get_attack_strength(strength_modifier))
	target_hit = body

func process_frame(_delta: float) -> StateNode:
	if not animation_player.is_playing():
		return state_machine.state_list["IdleState"]
	
	if target_hit == null:
		return null
	
	if target_hit is HittableBodyComponent:
		target_hit.on_hit(hurtboxes_list[current_attack_resource.attack_range].global_position, GameplayManager.player_node.get_player_forward_angle())
	SfxManager.stop_sound(sfx)
	return state_machine.state_list["KnockbackedState"]

func _on_short_hurt_zone_area_body_entered(body: Node3D) -> void:
	if not hurtzone_active:
		return;
	if current_attack_resource.attack_range == ATTACK_RANGES.SHORT:
		print("_on_short_hurt_zone_area_body_entered hit")
		on_hit(body)

func _on_medium_hurt_zone_area_body_entered(body: Node3D) -> void:
	if not hurtzone_active:
		return;
	if current_attack_resource.attack_range == ATTACK_RANGES.MEDIUM:
		print("_on_medium_hurt_zone_area_body_entered hit")
		on_hit(body)
