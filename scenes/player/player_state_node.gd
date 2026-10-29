extends StateNode
class_name PlayerStateNode

var player_node :PlayerNode


func on_entering_state() -> void:
	pass

func on_exiting_state() -> void:
	pass

func process_input(event: InputEvent) -> StateNode:
	return null

func process_frame(delta: float) -> StateNode:
	return null

func process_physics(delta: float) -> StateNode:
	return null
