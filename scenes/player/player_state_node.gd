extends StateNode
class_name PlayerStateNode

var dashing_state :PlayerStateNode
var falling_state :PlayerStateNode
var idle_state :PlayerStateNode
var jumping_state :PlayerStateNode
var walking_state :PlayerStateNode

var player_node :PlayerNode

func _ready() -> void:
	if get_parent() == null:
		return
	
	for sibling in get_parent().get_children():
		if sibling.name == "DashingState":
			dashing_state = sibling as PlayerStateNode
		if sibling.name == "FallingState":
			falling_state = sibling as PlayerStateNode
		if sibling.name == "IdleState":
			idle_state = sibling as PlayerStateNode
		if sibling.name == "JumpingState":
			jumping_state = sibling as PlayerStateNode
		if sibling.name == "WalkingState":
			walking_state = sibling as PlayerStateNode

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
