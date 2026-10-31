extends StateNode
class_name PlayerStateNode

var player_node :PlayerNode


func on_entering_state(_previous_state :StateNode, state_data = null) -> void:
	pass

func on_exiting_state() -> void:
	pass

func process_input(event: InputEvent) -> StateNode:
	return null

func process_frame(delta: float) -> StateNode:
	return null

func process_physics(delta: float) -> StateNode:
	return null
