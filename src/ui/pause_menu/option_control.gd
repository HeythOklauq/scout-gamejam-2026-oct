extends Control
class_name OptionScreenNode

signal close_clicked()

const KEYBINDING_LINE = preload("uid://s5te32peh36n")
@onready var keybinding_container: VBoxContainer = %KeybindingContainer

var is_remapping := false
var remapping_target :KeybindingLineControl

func _ready() -> void:
	call_deferred("update_keybinding")

func update_keybinding() -> void:
	for child in keybinding_container.get_children():
		child.queue_free()
	
	for keybind_id in OptionsManager.KEYBINDS.keys():
		var tmp_keybinding_line = KEYBINDING_LINE.instantiate() as KeybindingLineControl
		tmp_keybinding_line.action_id = keybind_id
		tmp_keybinding_line.action_label = OptionsManager.KEYBINDS[keybind_id]
		tmp_keybinding_line.remapping_initialised.connect(_on_remapping_requested)
		keybinding_container.add_child(tmp_keybinding_line)

func _input(event: InputEvent) -> void:
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.is_pressed()):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(remapping_target.action_id)
			InputMap.action_add_event(remapping_target.action_id, event);
			
			remapping_target._update_display()
			is_remapping = false
			OptionsManager.save_data()
			
			accept_event()

func _on_remapping_requested(line :KeybindingLineControl) -> void:
	remapping_target = line
	is_remapping = true
	line.button.text = "Press a key"

func _on_close_button_pressed() -> void:
	close_clicked.emit()

func _on_reset_progress_button_pressed() -> void:
	GameplayManager.reset_data()

func _on_reset_keybinding_button_pressed() -> void:
	OptionsManager.reset_keybinding()
	update_keybinding()
