extends StateNode
class_name PlayerStateNode

func on_entering_state(_previous_state :StateNode) -> void:
	pass

func on_exiting_state() -> void:
	pass

func process_input(_event: InputEvent) -> StateNode:
	return null

func process_frame(_delta: float) -> StateNode:
	return null

func process_physics(_delta: float) -> StateNode:
	return null
