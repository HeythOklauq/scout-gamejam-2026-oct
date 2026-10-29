extends StateMachine
class_name PlayerStateMachine

var player_state :PlayerStateNode

func _ready() -> void:
	super()
	call_deferred("initialize_player_node_data")

func initialize_player_node_data() -> void:
	for child in get_children():
		child = child as PlayerStateNode
		child.player_node = find_parent("PlayerNode");


func switch_state_to(new_state :StateNode) -> void:
	if (new_state as PlayerStateNode) == null:
		return
	
	print("PlayerStateMachine.switch_state_to")
	super(new_state);
	player_state = new_state as PlayerStateNode


func _input(event: InputEvent) -> void:
	if player_state == null:
		return
	
	switch_state_to(player_state.process_input(event));
