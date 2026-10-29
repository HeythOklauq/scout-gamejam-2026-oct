extends Node
class_name StateMachine

var current_state :StateNode

@export var starting_state :StateNode

func _ready() -> void:
	call_deferred("switch_state_to", starting_state)

func switch_state_to(new_state :StateNode) -> void:
	if new_state == null:
		return
	
	print("StateMachine.switch_state_to")
	prints("Switch state: ", current_state, " to ", new_state)
	
	if not current_state == null:
		current_state.on_exiting_state()
	
	current_state = new_state;
	if not current_state == null:
		current_state.on_entering_state()

func _process(delta: float) -> void:
	if current_state == null:
		return
	
	switch_state_to(current_state.process_frame(delta));

func _physics_process(delta: float) -> void:
	if current_state == null:
		return
	
	switch_state_to(current_state.process_physics(delta));
