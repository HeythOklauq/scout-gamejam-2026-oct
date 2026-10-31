extends PlayerStateNode

var attack_type := AttackingState.ATTACK_TYPES.BUNT
var strength_modifier := 1.0

func process_frame(delta: float) -> StateNode:
	if player_node.attack_locked:
		return null
	
	if Input.is_action_pressed("Attack"):
		return state_machine.state_list["WindupState"]
	if Input.is_action_just_pressed("Bunt"):
		return state_machine.state_list["AttackingState"]
	
	return null
