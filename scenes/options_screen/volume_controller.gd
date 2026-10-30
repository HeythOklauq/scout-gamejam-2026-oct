@tool

extends Control


@onready var label: Label = $Label
@onready var h_slider: HSlider = $HSlider
@onready var check_button: CheckButton = $CheckButton

@export var audio_bus :OptionsManager.AUDIO_BUSES:
	set(_bus_index):
		audio_bus = _bus_index
		call_deferred("update_name")
		call_deferred("update_volume")

var is_initialized := false

func _ready() -> void:
	audio_bus = audio_bus;
	call_deferred("initialize")

func initialize() -> void:
	is_initialized = true

func update_name() -> void:
	if label == null:
		return
	label.text = OptionsManager.AUDIO_BUSES.keys()[audio_bus]

func update_volume() -> void:
	check_button.button_pressed = !OptionsManager.is_bus_mute(audio_bus);
	h_slider.value = OptionsManager.get_audio_level(audio_bus);

func _on_check_button_toggled(toggled_on: bool) -> void:
	if not is_initialized:
		return
	OptionsManager.set_bus_mute(audio_bus, !toggled_on);

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed or not is_initialized:
		return
	OptionsManager.set_audio_level(audio_bus, h_slider.value);
