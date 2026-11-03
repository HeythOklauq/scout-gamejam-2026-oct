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


func _input(event: InputEvent) -> void:
	if current_player_state == null:
		return
	
	switch_state_to(current_player_state.process_input(event));
