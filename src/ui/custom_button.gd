@tool
extends Control
class_name CustomButton

signal pressed()

@onready var button: Button = %Button
@onready var dynamic_control_component: DynamicControlComponent = %DynamicControlComponent

@export var text := "BUTTON":
	set(_text):
		text = _text
		_update_button()
@export var disabled := false:
	set(_disabled):
		disabled = _disabled
		_update_button()

func _ready() -> void:
	_update_button.call_deferred()

func _update_button() -> void:
	if button == null:
		return
	
	button.text = text
	button.disabled = disabled
	if not dynamic_control_component == null:
		dynamic_control_component.disabled = disabled


func _on_button_pressed() -> void:
	pressed.emit()
