extends HBoxContainer
class_name KeybindingLineControl

signal remapping_initialised(keybinding_line :KeybindingLineControl)

@export var action_label :String = ""
@export var action_id :String = ""

@onready var label: Label = $Label
@onready var button: Button = $Button

func _ready() -> void:
	call_deferred("_update_display")

func _update_display() -> void:
	InputMap.load_from_project_settings()
	
	var button_text := "[UNDEFINED]"
	var events := InputMap.action_get_events(action_id)
	if events.size() > 0:
		button_text = events[0].as_text().trim_suffix(" - Physical")
	
	button.text = button_text
	label.text = action_label

func _on_button_pressed() -> void:
	remapping_initialised.emit(self)
