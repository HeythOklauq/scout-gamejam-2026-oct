extends Node

func _ready() -> void:
	call_deferred("load_data");

#region SAVE DATA
var option_file_path :String = "user://options.json"

func load_data() -> void:
	if FileAccess.file_exists(option_file_path):
		var file = FileAccess.open(option_file_path, FileAccess.READ)
		var file_content = file.get_as_text()
		file.close()
		
		var file_parsed = JSON.parse_string(file_content)
		if file_parsed.has("audio"):
			load_audio_options(file_parsed.audio)
		if file_parsed.has("keybinding"):
			load_keybinding_data(file_parsed.keybinding)

func save_data() -> void:
	var file = FileAccess.open(option_file_path, FileAccess.WRITE_READ)
	
	var option_data = {} 
	option_data["audio"] = get_audio_options();
	option_data["keybinding"] = get_keybinding_data();
	
	file.store_string(JSON.stringify(option_data))
	file.close()
#endregion

#region AUDIO PARAMETERS
enum AUDIO_BUSES {
	MASTER,
	BGM,
	SFX,
	AMBIANT
}

func get_bus_name(audio_bus :AUDIO_BUSES) -> String:
	return AudioServer.get_bus_name(audio_bus);

func set_audio_level(audio_bus :AUDIO_BUSES, volume_linear :float) -> void:
	AudioServer.set_bus_volume_linear(audio_bus, volume_linear);
	save_data()
func get_audio_level(audio_bus :AUDIO_BUSES) -> float:
	return AudioServer.get_bus_volume_linear(audio_bus);

func set_bus_mute(audio_bus :AUDIO_BUSES, muted :bool) -> void:
	AudioServer.set_bus_mute(audio_bus, muted);
	save_data()
func is_bus_mute(audio_bus :AUDIO_BUSES) -> bool:
	return AudioServer.is_bus_mute(audio_bus);

func get_audio_options() -> Array:
	var result = []
	for bus_index in AUDIO_BUSES.values():
		result.push_back({
			"volume": AudioServer.get_bus_volume_linear(bus_index),
			"mute": AudioServer.is_bus_mute(bus_index)
		})
	return result;

func load_audio_options(audio_options :Array) -> void:
	for bus_index in audio_options.size():
		var bus_data = audio_options[bus_index] as Dictionary
		
		AudioServer.set_bus_volume_linear(bus_index, bus_data["volume"])
		AudioServer.set_bus_mute(bus_index, bus_data["mute"])

#endregion

#region KEYBINDING
var KEYBINDS := {
	"Forward": "Forward",
	"Backward": "Back",
	"StrafeLeft": "Left",
	"StrafeRight": "Right",
	"Jump": "Jump",
	"Dash": "Dash",
	"Attack": "Swing",
	"Bunt": "Bunt",
	"Cancel": "Cancel",
	"Interact": "Interact",
	"Pause": "Pause"
}

func reset_keybinding() -> void:
	InputMap.load_from_project_settings()
	call_deferred("save_data")

func get_keybinding_data() -> Dictionary:
	var result = {}
	for keybind_id in KEYBINDS.keys():
		var current_event = InputMap.action_get_events(keybind_id)[0] as InputEvent
		if current_event is InputEventKey:
			result[keybind_id] = OS.get_keycode_string(current_event.physical_keycode)
		if current_event is InputEventMouseButton:
			result[keybind_id] = str("mouse_", current_event.button_index);
	return result;

func load_keybinding_data(keybinding_data :Dictionary) -> void:
	for keybind_id in keybinding_data.keys():
		var event :InputEvent
		var key_label :String = keybinding_data[keybind_id]
		 
		if key_label.contains("mouse_"):
			event = InputEventMouseButton.new()
			event.button_index = int(key_label.split("_")[1])
		else:
			event = InputEventKey.new()
			event.physical_keycode = OS.find_keycode_from_string(key_label)
			prints("key_label", key_label, "event.keycode", event.keycode)
		
		InputMap.action_erase_events(keybind_id)
		InputMap.action_add_event(keybind_id, event);
#endregion
