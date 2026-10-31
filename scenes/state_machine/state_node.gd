extends Node
class_name StateNode

var state_machine :StateMachine

func is_valid_state() -> bool:
	return true;

func _ready() -> void:
	state_machine = get_parent() as StateMachine

func on_entering_state(_previous_state :StateNode, new_state_data = null) -> void:
	pass

func on_exiting_state() -> void:
	pass

func process_frame(delta: float) -> StateNode:
	return null

func process_physics(delta: float) -> StateNode:
	return null
