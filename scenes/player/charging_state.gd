extends PlayerStateNode

var time_passed := 0.0
var max_time := 1.0

func on_entering_state(_previous_state :StateNode, _state_data = null) -> void:
	time_passed = 0.0
	player_node.stamina_locked = true

func on_exiting_state() -> void:
	player_node.stamina_locked = false

func process_frame(_delta: float) -> StateNode:
	if Input.is_action_just_pressed("Bunt"):
		return state_machine.state_list["BuntState"]
	
	if not Input.is_action_pressed("Attack") or time_passed > max_time:
		return state_machine.state_list["SwingingState"]
	
	time_passed += _delta
	return null
