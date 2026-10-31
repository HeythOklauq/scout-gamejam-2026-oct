extends StateMachine
class_name PlayerStateMachine

var current_player_state :PlayerStateNode

func _ready() -> void:
	super()
	call_deferred("initialize_player_node_data")

func initialize_player_node_data() -> void:
	for child in get_children():
		child = child as PlayerStateNode
		if child != null:
			child.player_node = find_parent("PlayerNode");

func switch_state_to(new_state :StateNode, new_state_data = null) -> bool:
	if (new_state as PlayerStateNode) == null:
		return false
	
	if super(new_state, new_state_data):
		current_player_state = new_state as PlayerStateNode
		return true
	
	return false


func _input(event: InputEvent) -> void:
	if current_player_state == null:
		return
	
	switch_state_to(current_player_state.process_input(event));
