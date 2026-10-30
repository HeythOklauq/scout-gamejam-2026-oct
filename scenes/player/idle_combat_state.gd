extends PlayerStateNode

func process_frame(delta: float) -> StateNode:
	if player_node.attack_locked:
		return null
	
	if Input.is_action_just_pressed("Attack"):
		return state_machine.state_list["WindupState"]
	if Input.is_action_just_pressed("Bunt"):
		return state_machine.state_list["BuntState"]
	
	return null
