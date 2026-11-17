extends StateMachine
class_name PlayerStateMachine

var current_player_state :PlayerStateNode

func switch_state_to(new_state :StateNode) -> bool:
	if (new_state as PlayerStateNode) == null:
		return false
	
	if super(new_state):
		current_player_state = new_state as PlayerStateNode
		return true
	
	return false


func _unhandled_input(event: InputEvent) -> void:
	if current_player_state == null:
		return
	
	var input_handled = switch_state_to(current_player_state.process_input(event));
	if input_handled:
		get_tree().root.get_viewport().set_input_as_handled()
