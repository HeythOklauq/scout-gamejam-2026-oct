extends Node
class_name StateMachine

var current_state :StateNode

@export var starting_state :StateNode
var state_list :Dictionary[String, StateNode] = {}

func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	for child in get_children():
		state_list[child.name] = child as StateNode
	
	switch_state_to(starting_state)

func switch_state_to(new_state :StateNode) -> void:
	if new_state == null:
		return
	
	prints(name, "- Switch state: ", current_state, " to ", new_state)
	
	if not current_state == null:
		current_state.on_exiting_state()
	
	var tmp_previous_state = current_state; 
	current_state = new_state;
	if not current_state == null:
		current_state.on_entering_state(tmp_previous_state)

func _process(delta: float) -> void:
	if current_state == null or Engine.time_scale == 0.0:
		return
	
	switch_state_to(current_state.process_frame(delta));

func _physics_process(delta: float) -> void:
	if current_state == null or Engine.time_scale == 0.0:
		return
	
	switch_state_to(current_state.process_physics(delta));
